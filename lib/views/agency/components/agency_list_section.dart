import 'package:dlza_legal_app/core/blocs/agency/agency_bloc.dart';
import 'package:dlza_legal_app/views/agency/components/agency_card.dart';
import 'package:dlza_legal_app/views/agency/agency_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgencyListSection extends StatefulWidget {
  const AgencyListSection({super.key});

  @override
  State<AgencyListSection> createState() => _AgencyListSectionState();
}

class _AgencyListSectionState extends State<AgencyListSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<AgencyBloc>().state;
      if (state is AgencyLoaded &&
          state.hasNextPage &&
          !state.isLoadingMore) {
        context.read<AgencyBloc>().add(
          LoadAgencies(
            page: state.currentPage + 1,
            pageSize: state.agenciesPerPage,
            loadMore: true,
            filterByCity: state.selectedCity,
          ),
        );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

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
            controller: _scrollController,
            padding: const EdgeInsets.all(5),
            itemCount:
                state.filteredAgencies.length +
                (state.hasNextPage ? 1 : 0), // +1 para el indicador de carga
            itemBuilder: (context, index) {
              // Mostrar indicador de carga al final si hay más páginas
              if (index >= state.filteredAgencies.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final agency = state.filteredAgencies[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgencyDetailPage(agency: agency),
                    ),
                  );
                },
                child: AgencyCard(agency: agency),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
