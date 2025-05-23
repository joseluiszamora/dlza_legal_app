import 'package:bloc/bloc.dart';
import 'package:dlza_legal_app/core/models/employee.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Employee> _loadedEmployees = [];
  List<Area> _loadedAreas = [];

  EmployeeBloc() : super(EmployeeLoading()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<LoadEmployeeDetails>(_onLoadEmployeeDetails);
    on<SearchEmployees>(_onSearchEmployees);
    on<FilterByArea>(_onFilterByArea);
    on<ClearAreaFilter>(_onClearAreaFilter);
    on<FilterByDepartment>(_onFilterByDepartment);
    on<ClearDepartmentFilter>(_onClearDepartmentFilter);
  }

  Future<void> _onLoadEmployees(
    LoadEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(EmployeeLoading());

      // Cargar empleados con sus relaciones
      final employeesResponse = await _supabase
          .from('Empleado')
          .select('''
            *,
            area:Area(*),
            ciudad:Ciudad(*)
          ''')
          .eq('activo', true)
          .order('nombres', ascending: true);

      // Cargar áreas para los filtros
      final areasResponse = await _supabase
          .from('Area')
          .select('*')
          .order('nombre', ascending: true);

      _loadedEmployees =
          (employeesResponse as List<dynamic>)
              .map((e) => Employee.fromJson(e))
              .toList();

      _loadedAreas =
          (areasResponse as List<dynamic>)
              .map((e) => Area.fromJson(e))
              .toList();

      emit(
        EmployeeLoaded(
          employees: _loadedEmployees,
          filteredEmployees: _loadedEmployees,
          areas: _loadedAreas,
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
      if (_loadedEmployees.isEmpty) {
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
        final employee = _loadedEmployees.firstWhere(
          (e) => e.id == event.employeeId,
          orElse: () => throw Exception('Empleado no encontrado'),
        );
        emit(EmployeeDetailLoaded(employee));
      }
    } catch (e) {
      emit(EmployeeError('Error al cargar los detalles: ${e.toString()}'));
    }
  }

  void _onSearchEmployees(SearchEmployees event, Emitter<EmployeeState> emit) {
    if (state is! EmployeeLoaded) return;

    final currentState = state as EmployeeLoaded;
    final query = event.query.toLowerCase();

    List<Employee> filtered = currentState.employees;

    // Si hay un área seleccionada, primero filtramos por área
    if (currentState.selectedArea != null) {
      filtered =
          filtered
              .where(
                (employee) => employee.areaId == currentState.selectedArea!.id,
              )
              .toList();
    }

    // Luego filtramos por la consulta de búsqueda
    if (query.isNotEmpty) {
      filtered =
          filtered.where((employee) {
            final fullName =
                '${employee.nombres} ${employee.apellidos}'.toLowerCase();
            final position = employee.cargo.toLowerCase();
            final area = employee.areaNombre?.toLowerCase() ?? '';
            final document = employee.documento.toLowerCase();

            return fullName.contains(query) ||
                position.contains(query) ||
                area.contains(query) ||
                document.contains(query);
          }).toList();
    }

    emit(
      currentState.copyWith(
        filteredEmployees: filtered,
        searchQuery: event.query,
      ),
    );
  }

  void _onFilterByArea(FilterByArea event, Emitter<EmployeeState> emit) {
    if (state is! EmployeeLoaded) return;

    final currentState = state as EmployeeLoaded;
    final area = event.area;
    final filtered =
        currentState.employees
            .where((employee) => employee.areaId == area.id)
            .toList();

    emit(
      currentState.copyWith(filteredEmployees: filtered, selectedArea: area),
    );

    // Reaplicar la búsqueda de texto si existe
    if (currentState.searchQuery.isNotEmpty) {
      add(SearchEmployees(currentState.searchQuery));
    }
  }

  void _onClearAreaFilter(ClearAreaFilter event, Emitter<EmployeeState> emit) {
    if (state is! EmployeeLoaded) return;

    final currentState = state as EmployeeLoaded;
    emit(
      currentState.copyWith(
        filteredEmployees: currentState.employees,
        clearArea: true,
      ),
    );

    // Reaplicar la búsqueda de texto si existe
    if (currentState.searchQuery.isNotEmpty) {
      add(SearchEmployees(currentState.searchQuery));
    }
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
}
