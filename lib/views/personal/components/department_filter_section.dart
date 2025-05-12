import 'package:dlza_legal_app/core/blocs/employee/employee_bloc.dart';
import 'package:dlza_legal_app/core/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DepartmentFilterSection extends StatelessWidget {
  const DepartmentFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is! EmployeeLoaded) return Container();

        final loadedState = state as EmployeeLoaded;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildFilterChip(
                context: context,
                label: 'Todos',
                selected: loadedState.selectedDepartment == null,
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
                    selected: loadedState.selectedDepartment == department,
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
