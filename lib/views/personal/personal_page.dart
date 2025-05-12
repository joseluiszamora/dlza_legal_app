import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dlza_legal_app/core/models/employee.dart';

// BLoC
class EmployeeState {
  final List<Employee> employees;
  final List<Employee> filteredEmployees;
  final String searchQuery;
  final Department? selectedDepartment;

  EmployeeState({
    required this.employees,
    required this.filteredEmployees,
    this.searchQuery = '',
    this.selectedDepartment,
  });

  EmployeeState copyWith({
    List<Employee>? employees,
    List<Employee>? filteredEmployees,
    String? searchQuery,
    Department? selectedDepartment,
    bool? clearDepartment,
  }) {
    return EmployeeState(
      employees: employees ?? this.employees,
      filteredEmployees: filteredEmployees ?? this.filteredEmployees,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDepartment:
          clearDepartment == true
              ? null
              : selectedDepartment ?? this.selectedDepartment,
    );
  }
}

abstract class EmployeeEvent {}

class LoadEmployees extends EmployeeEvent {}

class SearchEmployees extends EmployeeEvent {
  final String query;
  SearchEmployees(this.query);
}

class FilterByDepartment extends EmployeeEvent {
  final Department department;
  FilterByDepartment(this.department);
}

class ClearDepartmentFilter extends EmployeeEvent {}

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeState(employees: [], filteredEmployees: [])) {
    on<LoadEmployees>(_onLoadEmployees);
    on<SearchEmployees>(_onSearchEmployees);
    on<FilterByDepartment>(_onFilterByDepartment);
    on<ClearDepartmentFilter>(_onClearDepartmentFilter);
  }

  void _onLoadEmployees(LoadEmployees event, Emitter<EmployeeState> emit) {
    // En un caso real, aquí se cargarían los datos desde una API
    emit(state.copyWith(employees: employees, filteredEmployees: employees));
  }

  void _onSearchEmployees(SearchEmployees event, Emitter<EmployeeState> emit) {
    final query = event.query.toLowerCase();

    List<Employee> filtered = state.employees;

    // Si hay un departamento seleccionado, primero filtramos por departamento
    if (state.selectedDepartment != null) {
      filtered =
          filtered
              .where(
                (employee) =>
                    employee.department == state.selectedDepartment!.name,
              )
              .toList();
    }

    // Luego filtramos por la consulta de búsqueda
    if (query.isNotEmpty) {
      filtered =
          filtered.where((employee) {
            final fullName =
                '${employee.name} ${employee.lastName}'.toLowerCase();
            final position = employee.position.toLowerCase();
            final area = employee.area.toLowerCase();

            return fullName.contains(query) ||
                position.contains(query) ||
                area.contains(query);
          }).toList();
    }

    emit(state.copyWith(filteredEmployees: filtered, searchQuery: event.query));
  }

  void _onFilterByDepartment(
    FilterByDepartment event,
    Emitter<EmployeeState> emit,
  ) {
    final department = event.department;
    final filtered =
        state.employees
            .where((employee) => employee.department == department.name)
            .toList();

    emit(
      state.copyWith(
        filteredEmployees: filtered,
        selectedDepartment: department,
      ),
    );

    // Reaplicar la búsqueda de texto si existe
    if (state.searchQuery.isNotEmpty) {
      add(SearchEmployees(state.searchQuery));
    }
  }

  void _onClearDepartmentFilter(
    ClearDepartmentFilter event,
    Emitter<EmployeeState> emit,
  ) {
    emit(
      state.copyWith(filteredEmployees: state.employees, clearDepartment: true),
    );

    // Reaplicar la búsqueda de texto si existe
    if (state.searchQuery.isNotEmpty) {
      add(SearchEmployees(state.searchQuery));
    }
  }
}

// Componentes de UI
class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc()..add(LoadEmployees()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Personal'), elevation: 0),
        body: Column(
          children: const [
            SearchSection(),
            DepartmentFilterSection(),
            Expanded(child: EmployeeListSection()),
          ],
        ),
      ),
    );
  }
}

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar empleado...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
        onChanged: (query) {
          context.read<EmployeeBloc>().add(SearchEmployees(query));
        },
      ),
    );
  }
}

class DepartmentFilterSection extends StatelessWidget {
  const DepartmentFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildFilterChip(
                context: context,
                label: 'Todos',
                selected: state.selectedDepartment == null,
                onSelected: (_) {
                  context.read<EmployeeBloc>().add(ClearDepartmentFilter());
                },
              ),
              const SizedBox(width: 8),
              ...Department.values.map((department) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildFilterChip(
                    context: context,
                    label: _getDepartmentLabel(department),
                    selected: state.selectedDepartment == department,
                    onSelected: (_) {
                      context.read<EmployeeBloc>().add(
                        FilterByDepartment(department),
                      );
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  String _getDepartmentLabel(Department department) {
    switch (department) {
      case Department.legal:
        return 'Legal';
      case Department.administracion:
        return 'Administración';
      case Department.contabilidad:
        return 'Contabilidad';
      case Department.recursosHumanos:
        return 'RRHH';
      case Department.marketing:
        return 'Marketing';
      case Department.tecnologia:
        return 'Tecnología';
      case Department.ventas:
        return 'Ventas';
      case Department.produccion:
        return 'Producción';
      case Department.logistica:
        return 'Logística';
      default:
        return department.name;
    }
  }
}

class EmployeeListSection extends StatelessWidget {
  const EmployeeListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state.filteredEmployees.isEmpty) {
          return const Center(
            child: Text(
              'No se encontraron empleados con los filtros aplicados',
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: state.filteredEmployees.length,
          itemBuilder: (context, index) {
            final employee = state.filteredEmployees[index];
            return EmployeeCard(employee: employee);
          },
        );
      },
    );
  }
}

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  const EmployeeCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(employee.image),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${employee.name} ${employee.lastName}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        employee.position,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Área: ${employee.area}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Departamento: ${_getDepartmentLabel(employee.department)}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.phone,
                  label: 'Llamar',
                  color: Colors.blue,
                  onPressed: () => _makePhoneCall(employee.phone),
                ),
                _buildActionButton(
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  color: Colors.green,
                  onPressed: () => _openWhatsApp(employee.phone),
                ),
                _buildActionButton(
                  icon: Icons.email,
                  label: 'Email',
                  color: Colors.red,
                  onPressed: () => _sendEmail(employee.email),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    // Eliminar cualquier caracter no numérico
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final Uri uri = Uri.parse('https://wa.me/$cleanNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters({'subject': 'Contacto desde la app'}),
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  String _getDepartmentLabel(String departmentName) {
    final department = Department.values.firstWhere(
      (d) => d.name == departmentName,
      orElse: () => Department.legal,
    );

    switch (department) {
      case Department.legal:
        return 'Legal';
      case Department.administracion:
        return 'Administración';
      case Department.contabilidad:
        return 'Contabilidad';
      case Department.recursosHumanos:
        return 'RRHH';
      case Department.marketing:
        return 'Marketing';
      case Department.tecnologia:
        return 'Tecnología';
      case Department.ventas:
        return 'Ventas';
      case Department.produccion:
        return 'Producción';
      case Department.logistica:
        return 'Logística';
      default:
        return departmentName;
    }
  }
}
