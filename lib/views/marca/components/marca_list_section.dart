import 'package:dlza_legal_app/core/blocs/marca/marca_bloc.dart';
import 'package:dlza_legal_app/views/marca/components/marca_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MarcaListSection extends StatefulWidget {
  const MarcaListSection({super.key});

  @override
  State<MarcaListSection> createState() => _MarcaListSectionState();
}

class _MarcaListSectionState extends State<MarcaListSection> {
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
      context.read<MarcaBloc>().add(LoadMoreMarcas());
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
    return BlocBuilder<MarcaBloc, MarcaState>(
      builder: (context, state) {
        if (state is MarcaLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MarcaError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error al cargar marcas',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<MarcaBloc>().add(const LoadMarcas());
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is MarcaLoaded) {
          if (state.marcas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No se encontraron marcas',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.searchQuery?.isNotEmpty == true
                        ? 'Intenta con otros términos de búsqueda'
                        : 'No hay marcas registradas',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<MarcaBloc>().add(RefreshMarcas());
            },
            child: Column(
              children: [
                // Información de resultados
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  width: double.infinity,
                  child: Text(
                    'Mostrando ${state.marcas.length} de ${state.totalItems} marcas',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ),
                // Lista de marcas
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount:
                        state.hasReachedMax
                            ? state.marcas.length
                            : state.marcas.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.marcas.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      return MarcaCard(marca: state.marcas[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
