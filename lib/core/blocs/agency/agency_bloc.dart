import 'package:bloc/bloc.dart';
import 'package:dlza_legal_app/core/models/agency.dart';
import 'package:dlza_legal_app/core/models/ciudad.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'agency_event.dart';
part 'agency_state.dart';

class AgencyBloc extends Bloc<AgencyEvent, AgencyState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Agency> _loadedAgencies = [];
  List<Ciudad> _loadedCities = [];

  AgencyBloc() : super(AgencyLoading()) {
    on<LoadAgencies>(_onLoadAgencies);
    on<LoadAgencyDetails>(_onLoadAgencyDetails);
    on<SearchAgencies>(_onSearchAgencies);
    on<FilterAgenciesByCity>(_onFilterAgenciesByCity);
    on<ClearCityFilter>(_onClearCityFilter);
    on<RefreshAgencies>(_onRefreshAgencies);
    on<LoadNextPage>(_onLoadNextPage);
    on<LoadPreviousPage>(_onLoadPreviousPage);
    on<GoToPage>(_onGoToPage);
  }

  Future<void> _onLoadAgencies(
    LoadAgencies event,
    Emitter<AgencyState> emit,
  ) async {
    try {
      // Obtener la ciudad seleccionada actual o usar la del evento
      String? selectedCity = event.filterByCity;
      String searchQuery = '';

      if (selectedCity == null && state is AgencyLoaded) {
        final currentState = state as AgencyLoaded;
        selectedCity = currentState.selectedCity;
        searchQuery = currentState.searchQuery;
      }

      // Si es una carga adicional, mostrar estado de carga
      if (event.loadMore && state is AgencyLoaded) {
        final currentState = state as AgencyLoaded;
        emit(currentState.copyWith(isLoadingMore: true));
      } else {
        emit(AgencyLoading());
      }

      // Primero cargar ciudades si no están cargadas
      if (_loadedCities.isEmpty) {
        final citiesResponse = await _supabase
            .from('Ciudad')
            .select('*')
            .order('nombre', ascending: true);

        _loadedCities =
            (citiesResponse as List<dynamic>)
                .map((e) => Ciudad.fromJson(e))
                .toList();
      }

      // Construir la consulta base
      var countQuery = _supabase.from('Agencia').select('id');

      var agenciesQuery = _supabase.from('Agencia').select('''
            *,
            agente:Agente(*),
            ciudad:Ciudad(*),
            contratos:ContratoAgencia(*)
          ''');

      // Aplicar filtro por ciudad si existe
      if (selectedCity != null) {
        final ciudadResponse = await _supabase
            .from('Ciudad')
            .select('id')
            .eq('nombre', selectedCity)
            .limit(1);

        if ((ciudadResponse as List).isNotEmpty) {
          final ciudadId = ciudadResponse.first['id'] as int;
          countQuery = countQuery.eq('ciudadId', ciudadId);
          agenciesQuery = agenciesQuery.eq('ciudadId', ciudadId);
        }
      }

      // Aplicar filtro de búsqueda si existe
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        countQuery = countQuery.ilike('nombre', '%$query%');
        agenciesQuery = agenciesQuery.ilike('nombre', '%$query%');
      }

      // Contar total de agencias
      final allAgenciesResponse = await countQuery;
      final totalAgencies = (allAgenciesResponse as List).length;
      final totalPages = (totalAgencies / event.pageSize).ceil();

      // Cargar agencias con paginación
      final offset = (event.page - 1) * event.pageSize;
      final agenciesResponse = await agenciesQuery
          .order('nombre', ascending: true)
          .range(offset, offset + event.pageSize - 1);

      final pageAgencies =
          (agenciesResponse as List<dynamic>)
              .map((e) => Agency.fromJson(e))
              .toList();

      // Si es loadMore, agregar a la lista existente
      List<Agency> currentAgencies = [];
      if (event.loadMore && state is AgencyLoaded) {
        final currentState = state as AgencyLoaded;
        currentAgencies = [...currentState.agencies, ...pageAgencies];
      } else {
        currentAgencies = pageAgencies;
        _loadedAgencies = pageAgencies; // Guardar para búsquedas locales
      }

      emit(
        AgencyLoaded(
          agencies: currentAgencies,
          filteredAgencies: currentAgencies,
          cities: _loadedCities,
          selectedCity: selectedCity,
          searchQuery: searchQuery,
          currentPage: event.page,
          totalPages: totalPages,
          totalAgencies: totalAgencies,
          agenciesPerPage: event.pageSize,
          hasNextPage: event.page < totalPages,
          hasPreviousPage: event.page > 1,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(AgencyError('Error al cargar las agencias: ${e.toString()}'));
    }
  }

  Future<void> _onLoadAgencyDetails(
    LoadAgencyDetails event,
    Emitter<AgencyState> emit,
  ) async {
    try {
      // Si las agencias aún no están cargadas, intentamos cargar la específica
      if (_loadedAgencies.isEmpty) {
        final response = await _supabase
            .from('Agencia')
            .select('''
              *,
              agente:Agente(*),
              ciudad:Ciudad(*),
              contratos:ContratoAgencia(*)
            ''')
            .eq('id', event.agencyId)
            .limit(1);

        if ((response as List).isNotEmpty) {
          final agency = Agency.fromJson(response.first);
          emit(AgencyDetailLoaded(agency));
          return;
        }
      } else {
        // Si ya tenemos las agencias cargadas, buscamos por ID
        final agency = _loadedAgencies.firstWhere(
          (e) => e.id == event.agencyId,
          orElse: () => throw Exception('Agencia no encontrada'),
        );
        emit(AgencyDetailLoaded(agency));
      }
    } catch (e) {
      emit(AgencyError('Error al cargar los detalles: ${e.toString()}'));
    }
  }

  Future<void> _onSearchAgencies(
    SearchAgencies event,
    Emitter<AgencyState> emit,
  ) async {
    if (state is! AgencyLoaded) return;

    final currentState = state as AgencyLoaded;
    final query = event.query.toLowerCase();

    try {
      // Si la búsqueda está vacía, recargar agencias normales
      if (query.isEmpty) {
        add(
          LoadAgencies(
            page: 1,
            pageSize: currentState.agenciesPerPage,
            filterByCity: currentState.selectedCity,
          ),
        );
        return;
      }

      emit(AgencyLoading());

      // Construir la consulta base
      var countQuery = _supabase.from('Agencia').select('id');

      var agenciesQuery = _supabase.from('Agencia').select('''
            *,
            agente:Agente(*),
            ciudad:Ciudad(*),
            contratos:ContratoAgencia(*)
          ''');

      // Aplicar filtro por ciudad si existe
      if (currentState.selectedCity != null) {
        final ciudadResponse = await _supabase
            .from('Ciudad')
            .select('id')
            .eq('nombre', currentState.selectedCity!)
            .limit(1);

        if ((ciudadResponse as List).isNotEmpty) {
          final ciudadId = ciudadResponse.first['id'] as int;
          countQuery = countQuery.eq('ciudadId', ciudadId);
          agenciesQuery = agenciesQuery.eq('ciudadId', ciudadId);
        }
      }

      // Aplicar filtros de búsqueda - solo por nombre de agencia
      countQuery = countQuery.ilike('nombre', '%$query%');
      agenciesQuery = agenciesQuery.ilike('nombre', '%$query%');

      // Contar total de agencias que coinciden
      final countResponse = await countQuery;
      final totalAgencies = (countResponse as List).length;
      final totalPages = (totalAgencies / currentState.agenciesPerPage).ceil();

      // Cargar agencias que coinciden con la búsqueda
      final agenciesResponse = await agenciesQuery
          .order('nombre', ascending: true)
          .range(0, currentState.agenciesPerPage - 1);

      final searchResults =
          (agenciesResponse as List<dynamic>)
              .map((e) => Agency.fromJson(e))
              .toList();

      emit(
        AgencyLoaded(
          agencies: searchResults,
          filteredAgencies: searchResults,
          cities: currentState.cities,
          selectedCity: currentState.selectedCity,
          searchQuery: event.query,
          currentPage: 1,
          totalPages: totalPages,
          totalAgencies: totalAgencies,
          agenciesPerPage: currentState.agenciesPerPage,
          hasNextPage: totalPages > 1,
          hasPreviousPage: false,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      print(e.toString());
      emit(AgencyError('Error en la búsqueda: ${e.toString()}'));
    }
  }

  void _onFilterAgenciesByCity(
    FilterAgenciesByCity event,
    Emitter<AgencyState> emit,
  ) {
    if (state is! AgencyLoaded) return;

    final currentState = state as AgencyLoaded;
    final city = event.city;

    // Usar LoadAgencies con el filtro de ciudad
    add(
      LoadAgencies(
        page: 1,
        pageSize: currentState.agenciesPerPage,
        filterByCity: city,
      ),
    );
  }

  void _onClearCityFilter(ClearCityFilter event, Emitter<AgencyState> emit) {
    if (state is! AgencyLoaded) return;

    final currentState = state as AgencyLoaded;

    // Recargar todas las agencias sin filtro
    add(LoadAgencies(page: 1, pageSize: currentState.agenciesPerPage));
  }

  void _onRefreshAgencies(RefreshAgencies event, Emitter<AgencyState> emit) {
    if (state is! AgencyLoaded) return;

    final currentState = state as AgencyLoaded;

    // Recargar agencias manteniendo filtros actuales
    add(
      LoadAgencies(
        page: 1,
        pageSize: currentState.agenciesPerPage,
        filterByCity: currentState.selectedCity,
      ),
    );
  }

  void _onLoadNextPage(LoadNextPage event, Emitter<AgencyState> emit) {
    if (state is! AgencyLoaded) return;

    final currentState = state as AgencyLoaded;
    if (currentState.hasNextPage) {
      add(
        LoadAgencies(
          page: currentState.currentPage + 1,
          pageSize: currentState.agenciesPerPage,
          filterByCity: currentState.selectedCity,
        ),
      );
    }
  }

  void _onLoadPreviousPage(LoadPreviousPage event, Emitter<AgencyState> emit) {
    if (state is! AgencyLoaded) return;

    final currentState = state as AgencyLoaded;
    if (currentState.hasPreviousPage) {
      add(
        LoadAgencies(
          page: currentState.currentPage - 1,
          pageSize: currentState.agenciesPerPage,
          filterByCity: currentState.selectedCity,
        ),
      );
    }
  }

  void _onGoToPage(GoToPage event, Emitter<AgencyState> emit) {
    if (state is! AgencyLoaded) return;

    final currentState = state as AgencyLoaded;
    if (event.page > 0 && event.page <= currentState.totalPages) {
      add(
        LoadAgencies(
          page: event.page,
          pageSize: currentState.agenciesPerPage,
          filterByCity: currentState.selectedCity,
        ),
      );
    }
  }
}
