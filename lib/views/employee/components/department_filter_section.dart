import 'package:dlza_legal_app/core/blocs/employee/employee_bloc.dart';
import 'package:dlza_legal_app/core/components/filter_chip_item.dart';
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

        final loadedState = state;

        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChipItem(
                  label: 'Todos',
                  isSelected: loadedState.selectedDepartment == null,
                  onSelected: (_) {
                    context.read<EmployeeBloc>().add(ClearDepartmentFilter());
                  },
                ),
                const SizedBox(width: 8),
                ...Department.values.map((department) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChipItem(
                      label: _getDepartmentLabel(department),
                      isSelected: loadedState.selectedDepartment == department,
                      onSelected: (_) {
                        context.read<EmployeeBloc>().add(
                          FilterByDepartment(department),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
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
    }
  }
}
