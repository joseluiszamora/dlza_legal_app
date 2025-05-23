import 'package:dlza_legal_app/views/employee/components/area_filter_section.dart';
import 'package:dlza_legal_app/views/employee/components/employee_list_section.dart';
import 'package:dlza_legal_app/views/employee/components/search_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dlza_legal_app/core/blocs/employee/employee_bloc.dart';

class EmployeePage extends StatelessWidget {
  const EmployeePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeBloc()..add(LoadEmployees()),
      child: SafeArea(
        child: Column(
          children: [
            SearchSection(),
            AreaFilterSection(),
            Expanded(child: EmployeeListSection()),
          ],
        ),
      ),
    );
  }
}
