import 'package:dlza_legal_app/core/blocs/agency/agency_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        context.read<AgencyBloc>().add(LoadAgencies());
      } else {
        context.read<AgencyBloc>().add(SearchAgencies(query.trim()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar agencia por nombre, agente o ciudad...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<AgencyBloc>().add(LoadAgencies());
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: IconButton(
              icon: Icon(Icons.filter_list, color: theme.colorScheme.primary),
              tooltip: 'Filtros',
              onPressed: () {
                // Aquí se podría implementar un modal de filtros avanzados
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Filtros avanzados próximamente'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
