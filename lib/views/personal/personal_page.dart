import 'package:dlza_legal_app/views/personal/components/department_filter_section.dart';
import 'package:dlza_legal_app/views/personal/components/employee_list_section.dart';
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
