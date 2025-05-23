import 'package:dlza_legal_app/core/models/area.dart';
import 'package:dlza_legal_app/core/models/employee.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Employee> _allEmployees = [];
  List<Area> _loadedAreas = [];

  EmployeeBloc() : super(EmployeeLoading()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<LoadEmployeeDetails>(_onLoadEmployeeDetails);
    on<SearchEmployees>(_onSearchEmployees);
    on<FilterByArea>(_onFilterByArea);
    on<ClearAreaFilter>(_onClearAreaFilter);
    on<FilterByDepartment>(_onFilterByDepartment);
    on<ClearDepartmentFilter>(_onClearDepartmentFilter);
    on<LoadNextPage>(_onLoadNextPage);
    on<LoadPreviousPage>(_onLoadPreviousPage);
    on<GoToPage>(_onGoToPage);
  }

  Future<void> _onLoadEmployees(
    LoadEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      // Obtener el área seleccionada actual o usar la del evento
      Area? selectedArea = event.filterByArea;
      String searchQuery = '';

      if (selectedArea == null && state is EmployeeLoaded) {
        final currentState = state as EmployeeLoaded;
        selectedArea = currentState.selectedArea;
        searchQuery = currentState.searchQuery;
      }

      // Si es una carga adicional, mostrar estado de carga
      if (event.loadMore && state is EmployeeLoaded) {
        final currentState = state as EmployeeLoaded;
        emit(currentState.copyWith(isLoadingMore: true));
      } else {
        emit(EmployeeLoading());
      }

      // Primero cargar áreas si no están cargadas
      if (_loadedAreas.isEmpty) {
        final areasResponse = await _supabase
            .from('Area')
            .select('*')
            .order('nombre', ascending: true);

        _loadedAreas =
            (areasResponse as List<dynamic>)
                .map((e) => Area.fromJson(e))
                .toList();
      }

      // Construir la consulta base
      var countQuery = _supabase
          .from('Empleado')
          .select('id')
          .eq('activo', true);

      var employeesQuery = _supabase
          .from('Empleado')
          .select('''
            *,
            area:Area(*),
            ciudad:Ciudad(*)
          ''')
          .eq('activo', true);

      // Aplicar filtro por área si existe
      if (selectedArea != null) {
        countQuery = countQuery.eq('areaId', selectedArea.id);
        employeesQuery = employeesQuery.eq('areaId', selectedArea.id);
      }

      // Aplicar filtro de búsqueda si existe
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        countQuery = countQuery.or(
          'nombres.ilike.%$query%,apellidos.ilike.%$query%,cargo.ilike.%$query%,documento.ilike.%$query%',
        );

        employeesQuery = employeesQuery.or(
          'nombres.ilike.%$query%,apellidos.ilike.%$query%,cargo.ilike.%$query%,documento.ilike.%$query%',
        );
      }

      // Contar total de empleados
      final allEmployeesResponse = await countQuery;
      final totalEmployees = (allEmployeesResponse as List).length;
      final totalPages = (totalEmployees / event.pageSize).ceil();

      // Cargar empleados con paginación
      final offset = (event.page - 1) * event.pageSize;
      final employeesResponse = await employeesQuery
          .order('nombres', ascending: true)
          .range(offset, offset + event.pageSize - 1);

      final pageEmployees =
          (employeesResponse as List<dynamic>)
              .map((e) => Employee.fromJson(e))
              .toList();

      // Si es loadMore, agregar a la lista existente
      List<Employee> currentEmployees = [];
      if (event.loadMore && state is EmployeeLoaded) {
        final currentState = state as EmployeeLoaded;
        currentEmployees = [...currentState.employees, ...pageEmployees];
      } else {
        currentEmployees = pageEmployees;
        _allEmployees = pageEmployees; // Guardar para búsquedas locales
      }

      emit(
        EmployeeLoaded(
          employees: currentEmployees,
          filteredEmployees: currentEmployees,
          areas: _loadedAreas,
          selectedArea: selectedArea,
          searchQuery: searchQuery,
          currentPage: event.page,
          totalPages: totalPages,
          totalEmployees: totalEmployees,
          employeesPerPage: event.pageSize,
          hasNextPage: event.page < totalPages,
          hasPreviousPage: event.page > 1,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(EmployeeError('Error al cargar los empleados: ${e.toString()}'));
    }
  }

  Future<void> _onLoadEmployeeDetails(
    LoadEmployeeDetails event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      // Si los empleados aún no están cargados, intentamos cargar el específico
      if (_allEmployees.isEmpty) {
        final response = await _supabase
            .from('Empleado')
            .select('''
              *,
              area:Area(*),
              ciudad:Ciudad(*)
            ''')
            .eq('id', event.employeeId)
            .eq('activo', true)
            .limit(1);

        if ((response as List).isNotEmpty) {
          final employee = Employee.fromJson(response.first);
          emit(EmployeeDetailLoaded(employee));
          return;
        }
      } else {
        // Si ya tenemos los empleados cargados, buscamos por ID
        final employee = _allEmployees.firstWhere(
          (e) => e.id == event.employeeId,
          orElse: () => throw Exception('Empleado no encontrado'),
        );
        emit(EmployeeDetailLoaded(employee));
      }
    } catch (e) {
      emit(EmployeeError('Error al cargar los detalles: ${e.toString()}'));
    }
  }

  void _onSearchEmployees(
    SearchEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    if (state is! EmployeeLoaded) return;

    final currentState = state as EmployeeLoaded;
    final query = event.query.toLowerCase();

    try {
      // Si la búsqueda está vacía, recargar empleados normales
      if (query.isEmpty) {
        add(
          LoadEmployees(
            page: 1,
            pageSize: currentState.employeesPerPage,
            filterByArea: currentState.selectedArea,
          ),
        );
        return;
      }

      emit(EmployeeLoading());

      // Construir la consulta base
      var countQuery = _supabase
          .from('Empleado')
          .select('id')
          .eq('activo', true);

      var employeesQuery = _supabase
          .from('Empleado')
          .select('''
            *,
            area:Area(*),
            ciudad:Ciudad(*)
          ''')
          .eq('activo', true);

      // Aplicar filtro por área si existe
      if (currentState.selectedArea != null) {
        countQuery = countQuery.eq('areaId', currentState.selectedArea!.id);
        employeesQuery = employeesQuery.eq(
          'areaId',
          currentState.selectedArea!.id,
        );
      }

      // Aplicar filtros de búsqueda usando textSearch de PostgreSQL
      // o filtros OR múltiples
      countQuery = countQuery.or(
        'nombres.ilike.%$query%,apellidos.ilike.%$query%,cargo.ilike.%$query%,documento.ilike.%$query%',
      );

      employeesQuery = employeesQuery.or(
        'nombres.ilike.%$query%,apellidos.ilike.%$query%,cargo.ilike.%$query%,documento.ilike.%$query%',
      );

      // Contar total de empleados que coinciden
      final countResponse = await countQuery;
      final totalEmployees = (countResponse as List).length;
      final totalPages =
          (totalEmployees / currentState.employeesPerPage).ceil();

      // Cargar empleados que coinciden con la búsqueda
      final employeesResponse = await employeesQuery
          .order('nombres', ascending: true)
          .range(0, currentState.employeesPerPage - 1);

      final searchResults =
          (employeesResponse as List<dynamic>)
              .map((e) => Employee.fromJson(e))
              .toList();

      emit(
        EmployeeLoaded(
          employees: searchResults,
          filteredEmployees: searchResults,
          areas: currentState.areas,
          selectedArea: currentState.selectedArea,
          searchQuery: event.query,
          currentPage: 1,
          totalPages: totalPages,
          totalEmployees: totalEmployees,
          employeesPerPage: currentState.employeesPerPage,
          hasNextPage: totalPages > 1,
          hasPreviousPage: false,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(EmployeeError('Error en la búsqueda: ${e.toString()}'));
    }
  }

  void _onFilterByArea(FilterByArea event, Emitter<EmployeeState> emit) {
    if (state is! EmployeeLoaded) return;

    final currentState = state as EmployeeLoaded;

    // Usar LoadEmployees con el filtro de área
    add(
      LoadEmployees(
        page: 1,
        pageSize: currentState.employeesPerPage,
        filterByArea: event.area,
      ),
    );
  }

  void _onClearAreaFilter(ClearAreaFilter event, Emitter<EmployeeState> emit) {
    if (state is! EmployeeLoaded) return;

    final currentState = state as EmployeeLoaded;

    // Recargar todos los empleados sin filtro
    add(LoadEmployees(page: 1, pageSize: currentState.employeesPerPage));
  }

  // Métodos de compatibilidad con el código existente
  void _onFilterByDepartment(
    FilterByDepartment event,
    Emitter<EmployeeState> emit,
  ) {
    if (state is! EmployeeLoaded) return;

    final currentState = state as EmployeeLoaded;
    final department = event.department;
    final filtered =
        currentState.employees
            .where((employee) => employee.department == department.name)
            .toList();

    emit(
      currentState.copyWith(
        filteredEmployees: filtered,
        selectedDepartment: department,
      ),
    );

    // Reaplicar la búsqueda de texto si existe
    if (currentState.searchQuery.isNotEmpty) {
      add(SearchEmployees(currentState.searchQuery));
    }
  }

  void _onClearDepartmentFilter(
    ClearDepartmentFilter event,
    Emitter<EmployeeState> emit,
  ) {
    if (state is! EmployeeLoaded) return;

    final currentState = state as EmployeeLoaded;
    emit(
      currentState.copyWith(
        filteredEmployees: currentState.employees,
        clearDepartment: true,
      ),
    );

    // Reaplicar la búsqueda de texto si existe
    if (currentState.searchQuery.isNotEmpty) {
      add(SearchEmployees(currentState.searchQuery));
    }
  }

  void _onLoadNextPage(LoadNextPage event, Emitter<EmployeeState> emit) {
    if (state is! EmployeeLoaded) return;

    final currentState = state as EmployeeLoaded;
    if (currentState.hasNextPage) {
      add(
        LoadEmployees(
          page: currentState.currentPage + 1,
          pageSize: currentState.employeesPerPage,
          filterByArea: currentState.selectedArea,
        ),
      );
    }
  }

  void _onLoadPreviousPage(
    LoadPreviousPage event,
    Emitter<EmployeeState> emit,
  ) {
    if (state is! EmployeeLoaded) return;

    final currentState = state as EmployeeLoaded;
    if (currentState.hasPreviousPage) {
      add(
        LoadEmployees(
          page: currentState.currentPage - 1,
          pageSize: currentState.employeesPerPage,
          filterByArea: currentState.selectedArea,
        ),
      );
    }
  }

  void _onGoToPage(GoToPage event, Emitter<EmployeeState> emit) {
    if (state is! EmployeeLoaded) return;

    final currentState = state as EmployeeLoaded;
    if (event.page > 0 && event.page <= currentState.totalPages) {
      add(
        LoadEmployees(
          page: event.page,
          pageSize: currentState.employeesPerPage,
          filterByArea: currentState.selectedArea,
        ),
      );
    }
  }
}
