import 'package:dlza_legal_app/views/home/components/birthdays_list.dart';
import 'package:dlza_legal_app/views/home/components/contracts_expiration_chart.dart';
import 'package:dlza_legal_app/views/home/components/user_profile_section.dart';
import 'package:dlza_legal_app/views/home/components/brands_expiration_list.dart';
import 'package:dlza_legal_app/views/home/components/employees_by_area_chart.dart';
import 'package:flutter/material.dart';
import 'package:dlza_legal_app/core/blocs/agency/agency_bloc.dart';
import 'package:dlza_legal_app/core/blocs/employee/employee_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AgencyBloc()..add(LoadAgencies())),
        BlocProvider(create: (context) => EmployeeBloc()..add(LoadEmployees())),
      ],
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Sección de perfil de usuario
              UserProfileSection(),

              //* Sección de cumpleaños próximos
              const SizedBox(height: 24),
              Text(
                'Cumpleaños Próximos',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              BirthdaysList(),

              //* Gráfico de contratos que finalizarán
              const SizedBox(height: 24),
              Text(
                'Contratos de Agencias por Vencer',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ContractsExpirationChart(),

              //* Lista de marcas próximas a vencer
              const SizedBox(height: 24),
              Text(
                'Marcas Próximas a Vencer',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              BrandsExpirationList(),

              //* Gráfico de empleados por área
              const SizedBox(height: 24),
              Text(
                'Distribución de Empleados por Área',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              EmployeesByAreaChart(),

              // Aquí puedes añadir más contenido para la página de inicio
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
