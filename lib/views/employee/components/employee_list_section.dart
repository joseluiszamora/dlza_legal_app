import 'package:dlza_legal_app/core/blocs/employee/employee_bloc.dart';
import 'package:dlza_legal_app/views/employee/components/employee_card.dart';
import 'package:dlza_legal_app/views/employee/employee_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeListSection extends StatefulWidget {
  const EmployeeListSection({super.key});

  @override
  State<EmployeeListSection> createState() => _EmployeeListSectionState();
}

class _EmployeeListSectionState extends State<EmployeeListSection> {
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
      final state = context.read<EmployeeBloc>().state;
      if (state is EmployeeLoaded &&
          state.hasNextPage &&
          !state.isLoadingMore) {
        context.read<EmployeeBloc>().add(
          LoadEmployees(
            page: state.currentPage + 1,
            pageSize: state.employeesPerPage,
            loadMore: true,
            filterByArea: state.selectedArea,
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
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EmployeeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${state.message}'),
              ],
            ),
          );
        } else if (state is EmployeeLoaded) {
          if (state.filteredEmployees.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No se encontraron empleados con los filtros aplicados',
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
                state.filteredEmployees.length +
                (state.hasNextPage ? 1 : 0), // +1 para el indicador de carga
            itemBuilder: (context, index) {
              // Mostrar indicador de carga al final si hay más páginas
              if (index >= state.filteredEmployees.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final employee = state.filteredEmployees[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EmployeeDetailPage(employee: employee),
                    ),
                  );
                },
                child: EmployeeCard(employee: employee),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
