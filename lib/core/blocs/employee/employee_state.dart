part of 'employee_bloc.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;
  final List<Employee> filteredEmployees;
  final List<Area> areas;
  final String searchQuery;
  final Area? selectedArea;
  final Department? selectedDepartment; // Mantenemos para compatibilidad

  const EmployeeLoaded({
    required this.employees,
    required this.filteredEmployees,
    required this.areas,
    this.searchQuery = '',
    this.selectedArea,
    this.selectedDepartment,
  });

  EmployeeLoaded copyWith({
    List<Employee>? employees,
    List<Employee>? filteredEmployees,
    List<Area>? areas,
    String? searchQuery,
    Area? selectedArea,
    Department? selectedDepartment,
    bool? clearArea,
    bool? clearDepartment,
  }) {
    return EmployeeLoaded(
      employees: employees ?? this.employees,
      filteredEmployees: filteredEmployees ?? this.filteredEmployees,
      areas: areas ?? this.areas,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedArea:
          clearArea == true ? null : selectedArea ?? this.selectedArea,
      selectedDepartment:
          clearDepartment == true
              ? null
              : selectedDepartment ?? this.selectedDepartment,
    );
  }

  @override
  List<Object> get props => [
    employees,
    filteredEmployees,
    areas,
    searchQuery,
    selectedArea ?? Area(id: -1, nombre: '', createdAt: DateTime.now()),
    selectedDepartment ?? Department.legal,
  ];
}

class EmployeeDetailLoaded extends EmployeeState {
  final Employee employee;

  const EmployeeDetailLoaded(this.employee);

  @override
  List<Object> get props => [employee];
}

class EmployeeError extends EmployeeState {
  final String message;

  const EmployeeError(this.message);

  @override
  List<Object> get props => [message];
}
