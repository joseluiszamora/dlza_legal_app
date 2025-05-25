import 'package:dlza_legal_app/core/blocs/marca/marca_bloc.dart';
import 'package:dlza_legal_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class MarcaSearchSection extends StatefulWidget {
  const MarcaSearchSection({super.key});

  @override
  State<MarcaSearchSection> createState() => _MarcaSearchSectionState();
}

class _MarcaSearchSectionState extends State<MarcaSearchSection> {
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
        context.read<MarcaBloc>().add(const LoadMarcas());
      } else {
        context.read<MarcaBloc>().add(SearchMarcas(query.trim()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar marcas por nombre...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<MarcaBloc>().add(const LoadMarcas());
                      setState(() {});
                    },
                  )
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
        onChanged: (value) {
          setState(() {});
          _onSearchChanged(value);
        },
        onSubmitted: (value) {
          _debounce?.cancel();
          if (value.trim().isNotEmpty) {
            context.read<MarcaBloc>().add(SearchMarcas(value.trim()));
          } else {
            context.read<MarcaBloc>().add(const LoadMarcas());
          }
        },
      ),
    );
  }
}
