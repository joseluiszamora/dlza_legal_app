import 'package:dlza_legal_app/core/blocs/employee/employee_bloc.dart';
import 'package:dlza_legal_app/views/personal/components/employee_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeListSection extends StatelessWidget {
  const EmployeeListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EmployeeError) {
          return Center(child: Text(state.message));
        } else if (state is EmployeeLoaded) {
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
        }

        return const SizedBox.shrink();
      },
    );
  }
}
