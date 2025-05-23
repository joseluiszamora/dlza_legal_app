import 'package:dlza_legal_app/core/blocs/employee/employee_bloc.dart';
import 'package:dlza_legal_app/core/components/filter_chip_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AreaFilterSection extends StatelessWidget {
  const AreaFilterSection({super.key});

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
                  label: 'Todas las áreas',
                  isSelected: loadedState.selectedArea == null,
                  onSelected: (_) {
                    context.read<EmployeeBloc>().add(ClearAreaFilter());
                  },
                ),
                const SizedBox(width: 8),
                ...loadedState.areas.map((area) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChipItem(
                      label: area.nombre,
                      isSelected: loadedState.selectedArea?.id == area.id,
                      onSelected: (_) {
                        context.read<EmployeeBloc>().add(FilterByArea(area));
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
}
