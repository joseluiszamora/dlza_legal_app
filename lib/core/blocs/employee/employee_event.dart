part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployees extends EmployeeEvent {}

class LoadEmployeeDetails extends EmployeeEvent {
  final int employeeId;

  const LoadEmployeeDetails(this.employeeId);

  @override
  List<Object> get props => [employeeId];
}

class SearchEmployees extends EmployeeEvent {
  final String query;

  const SearchEmployees(this.query);

  @override
  List<Object> get props => [query];
}

class FilterByArea extends EmployeeEvent {
  final Area area;

  const FilterByArea(this.area);

  @override
  List<Object> get props => [area];
}

class ClearAreaFilter extends EmployeeEvent {}

// Mantenemos compatibilidad con los eventos existentes
class FilterByDepartment extends EmployeeEvent {
  final Department department;

  const FilterByDepartment(this.department);

  @override
  List<Object> get props => [department];
}

class ClearDepartmentFilter extends EmployeeEvent {}
