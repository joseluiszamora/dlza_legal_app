import 'package:bloc/bloc.dart';
import 'package:dlza_legal_app/core/models/employee.dart';
import 'package:equatable/equatable.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc() : super(EmployeeInitial()) {
    on<LoadEmployees>(_onLoadEmployees);
    on<SearchEmployees>(_onSearchEmployees);
    on<FilterByDepartment>(_onFilterByDepartment);
    on<ClearDepartmentFilter>(_onClearDepartmentFilter);
  }

  void _onLoadEmployees(LoadEmployees event, Emitter<EmployeeState> emit) {
    try {
      // En un caso real, aquí se cargarían los datos desde una API
      emit(EmployeeLoaded(employees: employees, filteredEmployees: employees));
    } catch (e) {
      emit(EmployeeError('Error al cargar los empleados: $e'));
    }
  }

  void _onSearchEmployees(SearchEmployees event, Emitter<EmployeeState> emit) {
    if (state is! EmployeeLoaded) return;

    final currentState = state as EmployeeLoaded;
    final query = event.query.toLowerCase();

    List<Employee> filtered = currentState.employees;

    // Si hay un departamento seleccionado, primero filtramos por departamento
    if (currentState.selectedDepartment != null) {
      filtered =
          filtered
              .where(
                (employee) =>
                    employee.department ==
                    currentState.selectedDepartment!.name,
              )
              .toList();
    }

    // Luego filtramos por la consulta de búsqueda
    if (query.isNotEmpty) {
      filtered =
          filtered.where((employee) {
            final fullName =
                '${employee.name} ${employee.lastName}'.toLowerCase();
            final position = employee.position.toLowerCase();
            final area = employee.area.toLowerCase();

            return fullName.contains(query) ||
                position.contains(query) ||
                area.contains(query);
          }).toList();
    }

    emit(
      currentState.copyWith(
        filteredEmployees: filtered,
        searchQuery: event.query,
      ),
    );
  }

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
