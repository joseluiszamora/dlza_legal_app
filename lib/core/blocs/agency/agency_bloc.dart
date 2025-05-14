import 'package:bloc/bloc.dart';
import 'package:dlza_legal_app/core/models/agency.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'agency_event.dart';
part 'agency_state.dart';

class AgencyBloc extends Bloc<AgencyEvent, AgencyState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Agency> _loadedAgencies = [];

  AgencyBloc() : super(AgencyLoading()) {
    on<LoadAgencies>(_onLoadAgencies);
    on<LoadAgencyDetails>(_onLoadAgencyDetails);
    on<SearchAgencies>(_onSearchAgencies);
    on<FilterAgenciesByCity>(_onFilterAgenciesByCity);
    on<ClearCityFilter>(_onClearCityFilter);
  }

  Future<void> _onLoadAgencies(
    LoadAgencies event,
    Emitter<AgencyState> emit,
  ) async {
    try {
      emit(AgencyLoading());

      final response = await _supabase
          .from('Agencia')
          .select('*')
          .order('nombre', ascending: true);

      _loadedAgencies =
          (response as List<dynamic>).map((e) => Agency.fromJson(e)).toList();

      emit(
        AgencyLoaded(
          agencies: _loadedAgencies,
          filteredAgencies: _loadedAgencies,
        ),
      );
    } catch (e) {
      emit(AgencyError(e.toString()));
    }
  }

  Future<void> _onLoadAgencyDetails(
    LoadAgencyDetails event,
    Emitter<AgencyState> emit,
  ) async {
    try {
      // Si las agencias aún no están cargadas, intentamos cargarlas primero
      if (_loadedAgencies.isEmpty) {
        final response = await _supabase
            .from('Agencia')
            .select('*')
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
          (a) => a.id == event.agencyId,
          orElse: () => throw Exception('Agencia no encontrada'),
        );
        emit(AgencyDetailLoaded(agency));
      }
    } catch (e) {
      emit(AgencyError('Error al cargar los detalles: ${e.toString()}'));
    }
  }

  void _onSearchAgencies(SearchAgencies event, Emitter<AgencyState> emit) {
    if (state is! AgencyLoaded) return;

    final currentState = state as AgencyLoaded;
    final query = event.query.toLowerCase();

    List<Agency> filtered = currentState.agencies;

    // Si hay una ciudad seleccionada, primero filtramos por ciudad
    if (currentState.selectedCity != null) {
      filtered =
          filtered
              .where(
                (agency) =>
                    agency.city.toLowerCase() ==
                    currentState.selectedCity!.toLowerCase(),
              )
              .toList();
    }

    // Luego filtramos por la consulta de búsqueda
    if (query.isNotEmpty) {
      filtered =
          filtered.where((agency) {
            return agency.name.toLowerCase().contains(query) ||
                agency.agent.toLowerCase().contains(query);
          }).toList();
    }

    emit(
      currentState.copyWith(
        filteredAgencies: filtered,
        searchQuery: event.query,
      ),
    );
  }

  void _onFilterAgenciesByCity(
    FilterAgenciesByCity event,
    Emitter<AgencyState> emit,
  ) {
    if (state is! AgencyLoaded) return;

    final currentState = state as AgencyLoaded;
    final city = event.city;
    final filtered =
        currentState.agencies
            .where((agency) => agency.city.toLowerCase() == city.toLowerCase())
            .toList();

    emit(currentState.copyWith(filteredAgencies: filtered, selectedCity: city));

    // Reaplicar la búsqueda de texto si existe
    if (currentState.searchQuery.isNotEmpty) {
      add(SearchAgencies(currentState.searchQuery));
    }
  }

  void _onClearCityFilter(ClearCityFilter event, Emitter<AgencyState> emit) {
    if (state is! AgencyLoaded) return;

    final currentState = state as AgencyLoaded;
    emit(
      currentState.copyWith(
        filteredAgencies: currentState.agencies,
        clearCity: true,
      ),
    );

    // Reaplicar la búsqueda de texto si existe
    if (currentState.searchQuery.isNotEmpty) {
      add(SearchAgencies(currentState.searchQuery));
    }
  }
}
