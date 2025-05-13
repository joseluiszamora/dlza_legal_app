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
    on<AgencyEvent>((event, emit) {
      on<LoadAgencies>(_onLoadAgencies);
      on<LoadAgencyDetails>(_onLoadAgencyDetails);
    });
  }

  Future<void> _onLoadAgencies(
    LoadAgencies event,
    Emitter<AgencyState> emit,
  ) async {
    try {
      final response = await _supabase
          .from('Agencia')
          .select('*')
          .order('name', ascending: true);

      // if (response.error != null) {
      //   emit(AgencyError(response.error!.message));
      //   return;
      // }

      final List<dynamic> data = response;

      _loadedAgencies = data.map((e) => Agency.fromJson(e)).toList();

      emit(AgencyLoaded(agencies: _loadedAgencies));
    } catch (e) {
      emit(AgencyError(e.toString()));
    }
  }

  Future<void> _onLoadAgencyDetails(
    LoadAgencyDetails event,
    Emitter<AgencyState> emit,
  ) async {
    try {
      final agency = _loadedAgencies.firstWhere((a) => a.id == event.agencyId);
      emit(AgencyDetailLoaded(agency));
    } catch (e) {
      emit(AgencyError(e.toString()));
    }
  }
}
