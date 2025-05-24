import 'package:dlza_legal_app/core/blocs/agency/agency_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaginationSection extends StatelessWidget {
  const PaginationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AgencyBloc, AgencyState>(
      builder: (context, state) {
        if (state is! AgencyLoaded) {
          return const SizedBox.shrink();
        }

        final currentPage = state.currentPage;
        final totalPages = state.totalPages;

        if (totalPages <= 1) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            if (state.isLoadingMore)
              const LinearProgressIndicator()
            else
              const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Información de paginación
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Página $currentPage de $totalPages (${state.totalAgencies} agencias)',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Botones de navegación
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 16),

                        // Botón de primera página
                        _buildPageButton(
                          context: context,
                          icon: Icons.first_page,
                          onTap:
                              currentPage > 1
                                  ? () => context.read<AgencyBloc>().add(
                                    GoToPage(1),
                                  )
                                  : null,
                        ),

                        // Botón de página anterior
                        _buildPageButton(
                          context: context,
                          icon: Icons.chevron_left,
                          onTap:
                              state.hasPreviousPage
                                  ? () => context.read<AgencyBloc>().add(
                                    LoadPreviousPage(),
                                  )
                                  : null,
                        ),

                        // Números de página
                        ..._buildPageNumbers(context, state),

                        // Botón de página siguiente
                        _buildPageButton(
                          context: context,
                          icon: Icons.chevron_right,
                          onTap:
                              state.hasNextPage
                                  ? () => context.read<AgencyBloc>().add(
                                    LoadNextPage(),
                                  )
                                  : null,
                        ),

                        // Botón de última página
                        _buildPageButton(
                          context: context,
                          icon: Icons.last_page,
                          onTap:
                              currentPage < totalPages
                                  ? () => context.read<AgencyBloc>().add(
                                    GoToPage(totalPages),
                                  )
                                  : null,
                        ),

                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPageButton({
    required BuildContext context,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Opacity(
          opacity: onTap != null ? 1.0 : 0.5,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  onTap != null
                      ? theme.colorScheme.primary.withOpacity(0.1)
                      : null,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              icon,
              size: 20,
              color:
                  onTap != null
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPageNumbers(BuildContext context, AgencyLoaded state) {
    final currentPage = state.currentPage;
    final totalPages = state.totalPages;
    final List<Widget> pageNumbers = [];

    // Máximo número de páginas a mostrar antes/después de la página actual
    const maxPagesVisible = 2;

    // Calcular rango de páginas a mostrar
    int startPage = (currentPage - maxPagesVisible).clamp(1, totalPages);
    int endPage = (currentPage + maxPagesVisible).clamp(1, totalPages);

    // Asegurar que mostramos suficientes páginas
    if (endPage - startPage + 1 < (maxPagesVisible * 2 + 1)) {
      if (currentPage < totalPages / 2) {
        // Estamos más cerca del inicio, extender hacia adelante
        endPage = (startPage + (maxPagesVisible * 2)).clamp(1, totalPages);
      } else {
        // Estamos más cerca del final, extender hacia atrás
        startPage = (endPage - (maxPagesVisible * 2)).clamp(1, totalPages);
      }
    }

    // Primera página
    if (startPage > 1) {
      pageNumbers.add(_buildNumberButton(context, 1, currentPage == 1));
      if (startPage > 2) {
        pageNumbers.add(_buildEllipsis(context));
      }
    }

    // Páginas intermedias
    for (int i = startPage; i <= endPage; i++) {
      pageNumbers.add(_buildNumberButton(context, i, currentPage == i));
    }

    // Última página
    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pageNumbers.add(_buildEllipsis(context));
      }
      pageNumbers.add(
        _buildNumberButton(context, totalPages, currentPage == totalPages),
      );
    }

    return pageNumbers;
  }

  Widget _buildNumberButton(BuildContext context, int page, bool isSelected) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap:
            isSelected
                ? null
                : () => context.read<AgencyBloc>().add(GoToPage(page)),
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color:
                isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$page',
            style: TextStyle(
              color:
                  isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      child: Text(
        '...',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
