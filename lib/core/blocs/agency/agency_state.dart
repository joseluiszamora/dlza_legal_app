part of 'agency_bloc.dart';

abstract class AgencyState extends Equatable {
  const AgencyState();

  @override
  List<Object> get props => [];
}

class AgencyLoading extends AgencyState {}

class AgencyLoaded extends AgencyState {
  final List<Agency> agencies;
  final List<Agency> filteredAgencies;
  final String searchQuery;
  final String? selectedCity;

  const AgencyLoaded({
    required this.agencies,
    required this.filteredAgencies,
    this.searchQuery = '',
    this.selectedCity,
  });

  AgencyLoaded copyWith({
    List<Agency>? agencies,
    List<Agency>? filteredAgencies,
    String? searchQuery,
    String? selectedCity,
    bool? clearCity,
  }) {
    return AgencyLoaded(
      agencies: agencies ?? this.agencies,
      filteredAgencies: filteredAgencies ?? this.filteredAgencies,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCity:
          clearCity == true ? null : selectedCity ?? this.selectedCity,
    );
  }

  @override
  List<Object> get props => [
    agencies,
    filteredAgencies,
    searchQuery,
    selectedCity ?? '',
  ];
}

class AgencyDetailLoaded extends AgencyState {
  final Agency agency;

  const AgencyDetailLoaded(this.agency);

  @override
  List<Object> get props => [agency];
}

class AgencyError extends AgencyState {
  final String message;

  const AgencyError(this.message);

  @override
  List<Object> get props => [message];
}
