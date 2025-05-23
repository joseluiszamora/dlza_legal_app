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

  // Campos de paginación
  final int currentPage;
  final int totalPages;
  final int totalEmployees;
  final int employeesPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final bool isLoadingMore;

  const EmployeeLoaded({
    required this.employees,
    required this.filteredEmployees,
    required this.areas,
    this.searchQuery = '',
    this.selectedArea,
    this.selectedDepartment,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalEmployees = 0,
    this.employeesPerPage = 20,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.isLoadingMore = false,
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
    int? currentPage,
    int? totalPages,
    int? totalEmployees,
    int? employeesPerPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
    bool? isLoadingMore,
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
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalEmployees: totalEmployees ?? this.totalEmployees,
      employeesPerPage: employeesPerPage ?? this.employeesPerPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
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
    currentPage,
    totalPages,
    totalEmployees,
    employeesPerPage,
    hasNextPage,
    hasPreviousPage,
    isLoadingMore,
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
