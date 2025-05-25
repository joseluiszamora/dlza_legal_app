part of 'employee_bloc.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

class LoadEmployees extends EmployeeEvent {
  final int page;
  final int pageSize;
  final bool loadMore;
  final Area? filterByArea;

  const LoadEmployees({
    this.page = 1,
    this.pageSize = 20,
    this.loadMore = false,
    this.filterByArea,
  });

  @override
  List<Object> get props => [page, pageSize, loadMore, filterByArea ?? ''];
}

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

class LoadNextEmployeePage extends EmployeeEvent {}

class LoadPreviousEmployeePage extends EmployeeEvent {}

class GoToEmployeePage extends EmployeeEvent {
  final int page;

  const GoToEmployeePage(this.page);

  @override
  List<Object> get props => [page];
}

// Mantenemos compatibilidad con los eventos existentes
class FilterByDepartment extends EmployeeEvent {
  final Department department;

  const FilterByDepartment(this.department);

  @override
  List<Object> get props => [department];
}

class ClearDepartmentFilter extends EmployeeEvent {}
