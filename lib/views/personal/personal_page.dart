import 'package:dlza_legal_app/views/personal/components/department_filter_section.dart';
import 'package:dlza_legal_app/views/personal/components/employee_card.dart';
import 'package:dlza_legal_app/views/personal/components/search_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dlza_legal_app/core/blocs/employee/employee_bloc.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc()..add(LoadEmployees()),
      child: SafeArea(
        child: Column(
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

class EmployeeListSection extends StatelessWidget {
  const EmployeeListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeInitial) {
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
              return EmployeeCard(employee: employee);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
