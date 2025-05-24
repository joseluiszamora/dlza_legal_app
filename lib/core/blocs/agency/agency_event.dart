part of 'agency_bloc.dart';

abstract class AgencyEvent extends Equatable {
  const AgencyEvent();

  @override
  List<Object> get props => [];
}

class LoadAgencies extends AgencyEvent {
  final int page;
  final int pageSize;
  final bool loadMore;
  final String? filterByCity;

  const LoadAgencies({
    this.page = 1,
    this.pageSize = 20,
    this.loadMore = false,
    this.filterByCity,
  });

  @override
  List<Object> get props => [page, pageSize, loadMore, filterByCity ?? ''];
}

class LoadAgencyDetails extends AgencyEvent {
  final int agencyId;

  const LoadAgencyDetails(this.agencyId);

  @override
  List<Object> get props => [agencyId];
}

class SearchAgencies extends AgencyEvent {
  final String query;

  const SearchAgencies(this.query);

  @override
  List<Object> get props => [query];
}

class FilterAgenciesByCity extends AgencyEvent {
  final String city;

  const FilterAgenciesByCity(this.city);

  @override
  List<Object> get props => [city];
}

class ClearCityFilter extends AgencyEvent {}

class LoadNextPage extends AgencyEvent {}

class LoadPreviousPage extends AgencyEvent {}

class GoToPage extends AgencyEvent {
  final int page;

  const GoToPage(this.page);

  @override
  List<Object> get props => [page];
}
