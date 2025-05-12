part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployees extends EmployeeEvent {}

class SearchEmployees extends EmployeeEvent {
  final String query;

  const SearchEmployees(this.query);

  @override
  List<Object> get props => [query];
}

class FilterByDepartment extends EmployeeEvent {
  final Department department;

  const FilterByDepartment(this.department);

  @override
  List<Object> get props => [department];
}

class ClearDepartmentFilter extends EmployeeEvent {}
