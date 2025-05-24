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
  final List<Ciudad> cities;
  final String searchQuery;
  final String? selectedCity;

  // Campos de paginación
  final int currentPage;
  final int totalPages;
  final int totalAgencies;
  final int agenciesPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final bool isLoadingMore;

  const AgencyLoaded({
    required this.agencies,
    required this.filteredAgencies,
    required this.cities,
    this.searchQuery = '',
    this.selectedCity,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalAgencies = 0,
    this.agenciesPerPage = 20,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.isLoadingMore = false,
  });

  AgencyLoaded copyWith({
    List<Agency>? agencies,
    List<Agency>? filteredAgencies,
    List<Ciudad>? cities,
    String? searchQuery,
    String? selectedCity,
    bool? clearCity,
    int? currentPage,
    int? totalPages,
    int? totalAgencies,
    int? agenciesPerPage,
    bool? hasNextPage,
    bool? hasPreviousPage,
    bool? isLoadingMore,
  }) {
    return AgencyLoaded(
      agencies: agencies ?? this.agencies,
      filteredAgencies: filteredAgencies ?? this.filteredAgencies,
      cities: cities ?? this.cities,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCity:
          clearCity == true ? null : selectedCity ?? this.selectedCity,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalAgencies: totalAgencies ?? this.totalAgencies,
      agenciesPerPage: agenciesPerPage ?? this.agenciesPerPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [
    agencies,
    filteredAgencies,
    cities,
    searchQuery,
    selectedCity ?? '',
    currentPage,
    totalPages,
    totalAgencies,
    agenciesPerPage,
    hasNextPage,
    hasPreviousPage,
    isLoadingMore,
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
