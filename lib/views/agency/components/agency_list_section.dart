import 'package:dlza_legal_app/core/blocs/agency/agency_bloc.dart';
import 'package:dlza_legal_app/views/agency/components/agency_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            padding: const EdgeInsets.symmetric(vertical: 10),
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
