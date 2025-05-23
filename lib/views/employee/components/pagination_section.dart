import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dlza_legal_app/core/blocs/employee/employee_bloc.dart';

class PaginationSection extends StatelessWidget {
  const PaginationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is! EmployeeLoaded) return const SizedBox.shrink();

        if (state.totalPages <= 1) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Información de paginación
              Text(
                'Página ${state.currentPage} de ${state.totalPages} - '
                '${state.filteredEmployees.length} de ${state.totalEmployees} empleados',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Controles de paginación con Wrap para evitar overflow
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 4.0,
                runSpacing: 8.0,
                children: [
                  // Botón Primera página
                  _buildNavigationButton(
                    context,
                    icon: Icons.first_page,
                    tooltip: 'Primera página',
                    onPressed:
                        state.currentPage > 1
                            ? () => context.read<EmployeeBloc>().add(
                              const GoToPage(1),
                            )
                            : null,
                  ),

                  // Botón Página anterior
                  _buildNavigationButton(
                    context,
                    icon: Icons.chevron_left,
                    tooltip: 'Página anterior',
                    onPressed:
                        state.hasPreviousPage
                            ? () => context.read<EmployeeBloc>().add(
                              LoadPreviousPage(),
                            )
                            : null,
                  ),

                  // Páginas numeradas
                  ..._buildPageNumbers(context, state),

                  // Botón Página siguiente
                  _buildNavigationButton(
                    context,
                    icon: Icons.chevron_right,
                    tooltip: 'Página siguiente',
                    onPressed:
                        state.hasNextPage
                            ? () =>
                                context.read<EmployeeBloc>().add(LoadNextPage())
                            : null,
                  ),

                  // Botón Última página
                  _buildNavigationButton(
                    context,
                    icon: Icons.last_page,
                    tooltip: 'Última página',
                    onPressed:
                        state.currentPage < state.totalPages
                            ? () => context.read<EmployeeBloc>().add(
                              GoToPage(state.totalPages),
                            )
                            : null,
                  ),
                ],
              ),

              // Indicador de carga
              if (state.isLoadingMore)
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: LinearProgressIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Construye un botón de navegación reutilizable
  Widget _buildNavigationButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor:
              onPressed != null ? Theme.of(context).colorScheme.surface : null,
        ),
      ),
    );
  }

  /// Construye los números de página adaptándose al ancho disponible
  List<Widget> _buildPageNumbers(BuildContext context, EmployeeLoaded state) {
    final visiblePages = _getVisiblePages(state.currentPage, state.totalPages);

    return visiblePages.map((page) {
      if (page == 0) {
        // Indicador de páginas omitidas
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text('...', style: TextStyle(fontSize: 16)),
        );
      }

      final isCurrentPage = page == state.currentPage;
      return SizedBox(
        width: 40,
        height: 40,
        child: ElevatedButton(
          onPressed:
              !isCurrentPage
                  ? () => context.read<EmployeeBloc>().add(GoToPage(page))
                  : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor:
                isCurrentPage
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.surface,
            foregroundColor:
                isCurrentPage
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
            elevation: isCurrentPage ? 2 : 0,
          ),
          child: Text(
            page.toString(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }).toList();
  }

  /// Calcula qué páginas mostrar en la paginación
  /// Muestra hasta 5 páginas alrededor de la página actual
  List<int> _getVisiblePages(int currentPage, int totalPages) {
    const int maxVisible = 5;

    if (totalPages <= maxVisible) {
      return List.generate(totalPages, (i) => i + 1);
    }

    int start = (currentPage - 2).clamp(1, totalPages - maxVisible + 1);
    int end = (start + maxVisible - 1).clamp(maxVisible, totalPages);

    List<int> pages = [];

    // Agregar primera página si no está en el rango
    if (start > 1) {
      pages.add(1);
      if (start > 2) {
        pages.add(0); // Indicador de omisión
      }
    }

    // Agregar páginas del rango
    for (int i = start; i <= end; i++) {
      pages.add(i);
    }

    // Agregar última página si no está en el rango
    if (end < totalPages) {
      if (end < totalPages - 1) {
        pages.add(0); // Indicador de omisión
      }
      pages.add(totalPages);
    }

    return pages;
  }
}
