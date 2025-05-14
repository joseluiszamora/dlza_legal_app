import 'package:dlza_legal_app/views/agency/components/agency_card.dart';
import 'package:dlza_legal_app/views/agency/components/city_filter_section.dart';
import 'package:dlza_legal_app/views/personal/components/search_section.dart';
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
