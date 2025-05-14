import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dlza_legal_app/core/blocs/agency/agency_bloc.dart';
import 'package:dlza_legal_app/core/models/agency.dart';
import 'package:dlza_legal_app/views/agency/agency_detail.dart';

class AgencyPage extends StatelessWidget {
  const AgencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AgencyBloc()..add(LoadAgencies()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Agencias'), elevation: 0),
        body: Column(
          children: const [
            SearchSection(),
            CityFilterSection(),
            Expanded(child: AgencyListSection()),
          ],
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
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar agencia...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
        ),
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

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              _buildFilterChip(
                context: context,
                label: 'Todas',
                selected: loadedState.selectedCity == null,
                onSelected: (_) {
                  context.read<AgencyBloc>().add(ClearCityFilter());
                },
              ),
              const SizedBox(width: 8),
              ...availableCities.map((city) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildFilterChip(
                    context: context,
                    label: city,
                    selected: loadedState.selectedCity == city,
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
        );
      },
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required String label,
    required bool selected,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.3),
      checkmarkColor: Theme.of(context).primaryColor,
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
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is AgencyLoaded) {
          if (state.filteredAgencies.isEmpty) {
            return const Center(
              child: Text(
                'No se encontraron agencias con los filtros aplicados',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
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
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgencyDetail(agencyId: agency.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                agency.name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              _buildInfoRow(
                icon: Icons.person,
                text: 'Agente: ${agency.agent}',
              ),
              _buildInfoRow(
                icon: Icons.location_city,
                text: 'Ciudad: ${agency.city}',
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.local_atm,
                      text: 'Garantía: ${agency.formattedMontoGarantia}',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.security,
                      text: 'Tipo: ${agency.tipoGarantia}',
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.calendar_today,
                      text: 'Fin de contrato: ${agency.contratoFinFormatted}',
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildRemainingTime(agency.remainingTime),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingTime(String remainingTime) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4.0),
          Expanded(
            child: Text(
              remainingTime,
              style: TextStyle(fontSize: 12.0, color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
