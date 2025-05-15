import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dlza_legal_app/core/blocs/agency/agency_bloc.dart';
import 'package:dlza_legal_app/core/models/agency.dart';
import 'package:dlza_legal_app/views/agency/agency_detail.dart';
import 'package:dlza_legal_app/core/components/search_field.dart';
import 'package:dlza_legal_app/core/components/filter_chip_item.dart';
import 'package:dlza_legal_app/core/components/custom_card.dart';
import 'package:dlza_legal_app/core/components/section_header.dart';

class AgencyPage extends StatelessWidget {
  const AgencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AgencyBloc()..add(LoadAgencies()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Agencias'), centerTitle: true),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.background,
              ],
              stops: const [0.0, 0.2],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: const [
                SearchSection(),
                CityFilterSection(),
                Expanded(child: AgencyListSection()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: SearchField(
        hintText: 'Buscar agencia...',
        onChanged: (query) {
          context.read<AgencyBloc>().add(SearchAgencies(query));
        },
      ),
    );
  }
}

class CityFilterSection extends StatelessWidget {
  const CityFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgencyBloc, AgencyState>(
      builder: (context, state) {
        if (state is! AgencyLoaded) {
          return const SizedBox.shrink();
        }

        final loadedState = state as AgencyLoaded;

        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                ...availableCities.map((city) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChipItem(
                      label: city,
                      isSelected: loadedState.selectedCity == city,
                      onSelected: (_) {
                        context.read<AgencyBloc>().add(
                          FilterAgenciesByCity(city),
                        );
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AgencyListSection extends StatelessWidget {
  const AgencyListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgencyBloc, AgencyState>(
      builder: (context, state) {
        if (state is AgencyLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AgencyError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${state.message}'),
                TextButton(
                  onPressed: () {
                    context.read<AgencyBloc>().add(LoadAgencies());
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        } else if (state is AgencyLoaded) {
          if (state.filteredAgencies.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No se encontraron agencias con los filtros aplicados',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.filteredAgencies.length,
            itemBuilder: (context, index) {
              final agency = state.filteredAgencies[index];
              return AgencyCard(agency: agency);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class AgencyCard extends StatelessWidget {
  final Agency agency;

  const AgencyCard({super.key, required this.agency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AgencyDetail(agencyId: agency.id),
          ),
        );
      },
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre de la agencia con badge de ciudad
          Row(
            children: [
              Expanded(
                child: Text(
                  agency.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  agency.city,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Información del agente
          Row(
            children: [
              Icon(
                Icons.person,
                size: 16,
                color:
                    theme.brightness == Brightness.light
                        ? Colors.black54
                        : Colors.white70,
              ),
              const SizedBox(width: 8),
              Text(
                'Agente: ${agency.agent}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Información de garantía
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipo de Garantía',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.brightness == Brightness.light
                                ? Colors.black54
                                : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      agency.tipoGarantia,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monto de Garantía',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.brightness == Brightness.light
                                ? Colors.black54
                                : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      agency.formattedMontoGarantia,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Información del contrato
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fin de Contrato',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.brightness == Brightness.light
                                ? Colors.black54
                                : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      agency.contratoFinFormatted,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildRemainingTime(context, agency.remainingTime),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingTime(BuildContext context, String remainingTime) {
    Color color;
    IconData icon;

    if (remainingTime.contains('vencido')) {
      color = Colors.red;
      icon = Icons.warning;
    } else if (remainingTime.contains('días')) {
      color = Colors.orange;
      icon = Icons.access_time;
    } else {
      color = Colors.green;
      icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              remainingTime,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
