import 'package:dlza_legal_app/core/blocs/marca/marca_bloc.dart';
import 'package:dlza_legal_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarcaSearchSection extends StatefulWidget {
  const MarcaSearchSection({super.key});

  @override
  State<MarcaSearchSection> createState() => _MarcaSearchSectionState();
}

class _MarcaSearchSectionState extends State<MarcaSearchSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Buscar Marcas',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por nombre, registro, titular...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  _searchController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<MarcaBloc>().add(const LoadMarcas());
                        },
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {});
              if (value.isEmpty) {
                context.read<MarcaBloc>().add(const LoadMarcas());
              }
            },
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                context.read<MarcaBloc>().add(SearchMarcas(value));
              } else {
                context.read<MarcaBloc>().add(const LoadMarcas());
              }
            },
          ),
        ],
      ),
    );
  }
}
