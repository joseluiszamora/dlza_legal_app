import 'package:dlza_legal_app/core/blocs/employee/employee_bloc.dart';
import 'package:dlza_legal_app/views/employee/components/employee_card.dart';
import 'package:dlza_legal_app/views/employee/employee_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeListSection extends StatelessWidget {
  const EmployeeListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EmployeeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${state.message}'),
              ],
            ),
          );
        } else if (state is EmployeeLoaded) {
          if (state.filteredEmployees.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No se encontraron empleados con los filtros aplicados',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(5),
            itemCount: state.filteredEmployees.length,
            itemBuilder: (context, index) {
              final employee = state.filteredEmployees[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EmployeeDetailPage(employee: employee),
                    ),
                  );
                },
                child: EmployeeCard(employee: employee),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
