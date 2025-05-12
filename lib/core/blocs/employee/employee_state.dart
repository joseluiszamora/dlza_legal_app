part of 'employee_bloc.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee> employees;
  final List<Employee> filteredEmployees;
  final String searchQuery;
  final Department? selectedDepartment;

  const EmployeeLoaded({
    required this.employees,
    required this.filteredEmployees,
    this.searchQuery = '',
    this.selectedDepartment,
  });

  EmployeeLoaded copyWith({
    List<Employee>? employees,
    List<Employee>? filteredEmployees,
    String? searchQuery,
    Department? selectedDepartment,
    bool? clearDepartment,
  }) {
    return EmployeeLoaded(
      employees: employees ?? this.employees,
      filteredEmployees: filteredEmployees ?? this.filteredEmployees,
      searchQuery: searchQuery ?? this.searchQuery,
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
    searchQuery,
    selectedDepartment ?? Department.legal,
  ];
}

class EmployeeError extends EmployeeState {
  final String message;

  const EmployeeError(this.message);

  @override
  List<Object> get props => [message];
}
