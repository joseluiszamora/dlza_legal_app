import 'package:dlza_legal_app/core/blocs/agency/agency_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaginationOptionsSection extends StatelessWidget {
  const PaginationOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgencyBloc, AgencyState>(
      builder: (context, state) {
        if (state is! AgencyLoaded) {
          return const SizedBox.shrink();
        }

        final theme = Theme.of(context);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Información de resultados
              Expanded(
                child: Text(
                  'Mostrando ${state.filteredAgencies.length} de ${state.totalAgencies} agencias',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),

              // Selector de elementos por página
              Row(
                children: [
                  Text(
                    'Mostrar: ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: state.agenciesPerPage,
                    underline: Container(
                      height: 1,
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                    items:
                        [10, 20, 50, 100].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        context.read<AgencyBloc>().add(
                          LoadAgencies(
                            page: 1,
                            pageSize: newValue,
                            filterByCity: state.selectedCity,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
