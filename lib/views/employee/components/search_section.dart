import 'package:dlza_legal_app/core/blocs/employee/employee_bloc.dart';
import 'package:dlza_legal_app/core/components/filter_chip_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar empleado...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              onChanged: (query) {
                context.read<EmployeeBloc>().add(SearchEmployees(query));
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
              onPressed: () {
                final blocContext = context;

                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return BlocProvider.value(
                      value: blocContext.read<EmployeeBloc>(),
                      child: Builder(
                        builder:
                            (context) => Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.85,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Barra de título fija
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 12.0,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: theme.dividerColor,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Filtros',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed:
                                              () => Navigator.pop(context),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Contenido scrollable
                                  Flexible(
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Filtrar por área',
                                              style: theme.textTheme.titleSmall
                                                  ?.copyWith(
                                                    color:
                                                        theme
                                                            .colorScheme
                                                            .secondary,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            BlocBuilder<
                                              EmployeeBloc,
                                              EmployeeState
                                            >(
                                              builder: (context, state) {
                                                if (state is! EmployeeLoaded) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }

                                                return Wrap(
                                                  spacing: 8.0,
                                                  runSpacing: 8.0,
                                                  children: [
                                                    FilterChip(
                                                      label: const Text(
                                                        'Todas',
                                                      ),
                                                      selected:
                                                          state.selectedArea ==
                                                          null,
                                                      onSelected: (_) {
                                                        context
                                                            .read<
                                                              EmployeeBloc
                                                            >()
                                                            .add(
                                                              ClearAreaFilter(),
                                                            );
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ...state.areas.map((area) {
                                                      return FilterChip(
                                                        label: Text(
                                                          area.nombre,
                                                        ),
                                                        selected:
                                                            state
                                                                .selectedArea
                                                                ?.id ==
                                                            area.id,
                                                        onSelected: (_) {
                                                          context
                                                              .read<
                                                                EmployeeBloc
                                                              >()
                                                              .add(
                                                                FilterByArea(
                                                                  area,
                                                                ),
                                                              );
                                                          Navigator.pop(
                                                            context,
                                                          );
                                                        },
                                                      );
                                                    }),
                                                  ],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
