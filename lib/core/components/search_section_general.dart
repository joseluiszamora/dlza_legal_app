import 'dart:async';

import 'package:flutter/material.dart';

class SearchSectionGeneral extends StatefulWidget {
  const SearchSectionGeneral({
    super.key,
    required this.hintText,
    required this.onChangedText,
    required this.onClearText,
    required this.onFilter,
  });

  final String hintText;
  final void Function(String query) onChangedText;
  final VoidCallback onClearText;
  final VoidCallback onFilter;

  @override
  State<SearchSectionGeneral> createState() => _SearchSectionGeneralState();
}

class _SearchSectionGeneralState extends State<SearchSectionGeneral> {
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
      widget.onChangedText(query.trim());
      // if (query.trim().isEmpty) {
      //   // context.read<MarcaBloc>().add(const LoadMarcas());
      // } else {
      //   // context.read<MarcaBloc>().add(SearchMarcas(query.trim()));
      // }
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
                hintText: widget.hintText,
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: widget.onClearText,
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              onChanged: (value) {
                setState(() {});
                _onSearchChanged(value);
              },
              onSubmitted: (value) {
                _debounce?.cancel();
                widget.onChangedText(value.trim());
              },
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
              onPressed: widget.onFilter,
            ),
          ),
        ],
      ),
    );
  }
}
