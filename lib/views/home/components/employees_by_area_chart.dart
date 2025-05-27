import 'package:dlza_legal_app/core/blocs/employee/employee_bloc.dart';
import 'package:dlza_legal_app/core/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesByAreaChart extends StatelessWidget {
  const EmployeesByAreaChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              EmployeeBloc()..add(
                const LoadEmployees(pageSize: 1000),
              ), // Cargar todos los empleados
      child: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is EmployeeError) {
            return Container(
              height: 220,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 40, color: Colors.red[300]),
                  const SizedBox(height: 8),
                  Text(
                    'Error al cargar datos',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is EmployeeLoaded) {
            final employeesByArea = _groupEmployeesByArea(state.employees);

            if (employeesByArea.isEmpty) {
              return Container(
                height: 220,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No hay empleados registrados',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Container(
              height: 220,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Gráfico de pie
                  Expanded(
                    flex: 3,
                    child: PieChart(
                      PieChartData(
                        sections: _createPieChartSections(employeesByArea),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 35,
                        pieTouchData: PieTouchData(
                          touchCallback: (
                            FlTouchEvent event,
                            pieTouchResponse,
                          ) {
                            // Opcional: agregar interactividad
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Leyenda
                  Expanded(flex: 2, child: _buildLegend(employeesByArea)),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Map<String, int> _groupEmployeesByArea(List<dynamic> employees) {
    final Map<String, int> employeesByArea = {};

    for (final employee in employees) {
      final areaName = employee.area.isNotEmpty ? employee.area : 'Sin Área';
      employeesByArea[areaName] = (employeesByArea[areaName] ?? 0) + 1;
    }

    return employeesByArea;
  }

  List<PieChartSectionData> _createPieChartSections(
    Map<String, int> employeesByArea,
  ) {
    final total = employeesByArea.values.fold(0, (sum, count) => sum + count);
    final colors = _generateColors(employeesByArea.length);

    return employeesByArea.entries.map((entry) {
      final index = employeesByArea.keys.toList().indexOf(entry.key);
      final percentage = (entry.value / total * 100);

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: entry.value.toDouble(),
        title: percentage > 5 ? '${percentage.toStringAsFixed(0)}%' : '',
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: null, // Removemos el badge para evitar overlaps
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, int> employeesByArea) {
    final colors = _generateColors(employeesByArea.length);
    final total = employeesByArea.values.fold(0, (sum, count) => sum + count);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Total: $total',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children:
                  employeesByArea.entries.map((entry) {
                    final index = employeesByArea.keys.toList().indexOf(
                      entry.key,
                    );
                    final percentage = (entry.value / total * 100);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              color: colors[index % colors.length],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  '${entry.value} (${percentage.toStringAsFixed(0)}%)',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<Color> _generateColors(int count) {
    return [
      AppColors.primary,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
      Colors.lime,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.brown,
    ];
  }
}
