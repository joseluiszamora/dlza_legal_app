import 'package:dlza_legal_app/core/blocs/agency/agency_bloc.dart';
import 'package:dlza_legal_app/core/components/filter_chip_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CityFilterSection extends StatelessWidget {
  const CityFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgencyBloc, AgencyState>(
      builder: (context, state) {
        if (state is! AgencyLoaded) {
          return const SizedBox.shrink();
        }

        final loadedState = state;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              FilterChipItem(
                label: 'Todas',
                isSelected: loadedState.selectedCity == null,
                onSelected: (_) {
                  context.read<AgencyBloc>().add(ClearCityFilter());
                },
              ),
              const SizedBox(width: 8),
              // Usar las ciudades dinámicas desde el estado
              ...loadedState.cities.map((ciudad) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChipItem(
                    label: ciudad.nombre,
                    isSelected: loadedState.selectedCity == ciudad.nombre,
                    onSelected: (_) {
                      context.read<AgencyBloc>().add(
                        FilterAgenciesByCity(ciudad.nombre),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
