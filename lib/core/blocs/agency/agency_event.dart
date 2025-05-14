part of 'agency_bloc.dart';

abstract class AgencyEvent extends Equatable {
  const AgencyEvent();

  @override
  List<Object> get props => [];
}

class LoadAgencies extends AgencyEvent {}

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
