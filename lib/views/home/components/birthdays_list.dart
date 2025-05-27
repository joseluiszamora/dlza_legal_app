import 'package:dlza_legal_app/core/models/employee.dart';
import 'package:dlza_legal_app/core/blocs/employee/employee_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BirthdaysList extends StatefulWidget {
  const BirthdaysList({super.key});

  @override
  State<BirthdaysList> createState() => _BirthdaysListState();
}

class _BirthdaysListState extends State<BirthdaysList> {
  @override
  void initState() {
    super.initState();
    // Cargar empleados si no están cargados
    context.read<EmployeeBloc>().add(LoadEmployees());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoading) {
          return Container(
            height: 150,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is EmployeeError) {
          return Container(
            height: 150,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Error al cargar empleados',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          );
        }

        if (state is EmployeeLoaded) {
          final upcomingBirthdays = _getUpcomingBirthdays(state.employees, 15);

          return Container(
            height: 150,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                upcomingBirthdays.isEmpty
                    ? Center(
                      child: Text(
                        'No hay cumpleaños próximos',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                    : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: upcomingBirthdays.length,
                      itemBuilder: (context, index) {
                        final employee = upcomingBirthdays[index];
                        return _buildBirthdayCard(context, employee);
                      },
                    ),
          );
        }

        return Container(
          height: 150,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'No hay empleados cargados',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        );
      },
    );
  }

  Widget _buildBirthdayCard(BuildContext context, Employee employee) {
    final theme = Theme.of(context);
    final thisYearBirthday = _getThisYearBirthday(employee.birthDate);
    final daysRemaining = thisYearBirthday.difference(DateTime.now()).inDays;
    final today = DateTime.now();
    final isToday =
        thisYearBirthday.day == today.day &&
        thisYearBirthday.month == today.month;

    print(today.month);

    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side:
              isToday
                  ? BorderSide(color: theme.colorScheme.primary, width: 2)
                  : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(employee.image),
                  ),
                  if (isToday)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.cake,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                employee.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                _formatBirthday(employee.birthDate),
                style: theme.textTheme.bodySmall,
              ),
              isToday
                  ? Text(
                    '¡Hoy!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  : Text(
                    'En $daysRemaining días',
                    style: theme.textTheme.bodySmall,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  List<Employee> _getUpcomingBirthdays(List<Employee> employees, int limit) {
    final now = DateTime.now();
    final maxDateLimit = DateTime(
      now.year,
      now.month,
      now.day + 90,
    ); // 90 días a partir de hoy
    final employeesWithUpcomingBirthdays = <Employee>[];

    // Filtrar primero por cumpleaños dentro de 90 días
    for (var employee in employees) {
      final thisYearBirthday = _getThisYearBirthday(employee.birthDate);

      // Si el cumpleaños ya pasó este año, calculamos para el próximo año
      final nextBirthday =
          thisYearBirthday.isBefore(now)
              ? DateTime(
                now.year + 1,
                employee.birthDate.month,
                employee.birthDate.day,
              )
              : thisYearBirthday;

      // Solo incluir si está dentro del límite de 90 días
      if (nextBirthday.isBefore(maxDateLimit) ||
          nextBirthday.isAtSameMomentAs(maxDateLimit)) {
        employeesWithUpcomingBirthdays.add(employee);
      }
    }

    // Ordenar por proximidad del cumpleaños
    employeesWithUpcomingBirthdays.sort((a, b) {
      final aBirthday = _getThisYearBirthday(a.birthDate);
      final bBirthday = _getThisYearBirthday(b.birthDate);

      // Si el cumpleaños ya pasó este año, ajustamos para el próximo año
      final aNextBirthday =
          aBirthday.isBefore(now)
              ? DateTime(now.year + 1, a.birthDate.month, a.birthDate.day)
              : aBirthday;

      final bNextBirthday =
          bBirthday.isBefore(now)
              ? DateTime(now.year + 1, b.birthDate.month, b.birthDate.day)
              : bBirthday;

      return aNextBirthday.compareTo(bNextBirthday);
    });

    // Limitar a la cantidad solicitada
    return employeesWithUpcomingBirthdays.take(limit).toList();
  }

  DateTime _getThisYearBirthday(DateTime birthDate) {
    final now = DateTime.now();
    return DateTime(now.year, birthDate.month, birthDate.day);
  }

  String _formatBirthday(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }
}
