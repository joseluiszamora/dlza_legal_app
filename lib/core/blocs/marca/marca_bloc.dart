import 'package:bloc/bloc.dart';
import 'package:dlza_legal_app/core/models/marca.dart';
import 'package:dlza_legal_app/core/repositories/marca_repository.dart';
import 'package:equatable/equatable.dart';

part 'marca_event.dart';
part 'marca_state.dart';

class MarcaBloc extends Bloc<MarcaEvent, MarcaState> {
  final MarcaRepository _marcaRepository = MarcaRepository();

  MarcaBloc() : super(MarcaInitial()) {
    on<LoadMarcas>(_onLoadMarcas);
    on<LoadMoreMarcas>(_onLoadMoreMarcas);
    on<SearchMarcas>(_onSearchMarcas);
    on<RefreshMarcas>(_onRefreshMarcas);
    on<LoadMarcasProximasAVencer>(_onLoadMarcasProximasAVencer);
  }

  Future<void> _onLoadMarcas(LoadMarcas event, Emitter<MarcaState> emit) async {
    emit(MarcaLoading());

    try {
      final marcas = await _marcaRepository.getMarcas(
        page: 0,
        limit: 20,
        searchQuery: event.searchQuery,
      );

      final total = await _marcaRepository.getTotalMarcas(
        searchQuery: event.searchQuery,
      );

      emit(
        MarcaLoaded(
          marcas: marcas,
          hasReachedMax: marcas.length < 20,
          currentPage: 0,
          totalItems: total,
          searchQuery: event.searchQuery,
        ),
      );
    } catch (e) {
      emit(MarcaError(e.toString()));
    }
  }

  Future<void> _onLoadMoreMarcas(
    LoadMoreMarcas event,
    Emitter<MarcaState> emit,
  ) async {
    final currentState = state;
    if (currentState is MarcaLoaded && !currentState.hasReachedMax) {
      try {
        final moreMarcas = await _marcaRepository.getMarcas(
          page: currentState.currentPage + 1,
          limit: 20,
          searchQuery: currentState.searchQuery,
        );

        if (moreMarcas.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(
            currentState.copyWith(
              marcas: [...currentState.marcas, ...moreMarcas],
              currentPage: currentState.currentPage + 1,
              hasReachedMax: moreMarcas.length < 20,
            ),
          );
        }
      } catch (e) {
        emit(MarcaError(e.toString()));
      }
    }
  }

  Future<void> _onSearchMarcas(
    SearchMarcas event,
    Emitter<MarcaState> emit,
  ) async {
    emit(MarcaLoading());

    try {
      final marcas = await _marcaRepository.getMarcas(
        page: 0,
        limit: 20,
        searchQuery: event.query,
      );

      final total = await _marcaRepository.getTotalMarcas(
        searchQuery: event.query,
      );

      emit(
        MarcaLoaded(
          marcas: marcas,
          hasReachedMax: marcas.length < 20,
          currentPage: 0,
          totalItems: total,
          searchQuery: event.query,
        ),
      );
    } catch (e) {
      emit(MarcaError(e.toString()));
    }
  }

  Future<void> _onRefreshMarcas(
    RefreshMarcas event,
    Emitter<MarcaState> emit,
  ) async {
    final currentState = state;
    final searchQuery =
        currentState is MarcaLoaded ? currentState.searchQuery : null;

    try {
      final marcas = await _marcaRepository.getMarcas(
        page: 0,
        limit: 20,
        searchQuery: searchQuery,
      );

      final total = await _marcaRepository.getTotalMarcas(
        searchQuery: searchQuery,
      );

      emit(
        MarcaLoaded(
          marcas: marcas,
          hasReachedMax: marcas.length < 20,
          currentPage: 0,
          totalItems: total,
          searchQuery: searchQuery,
        ),
      );
    } catch (e) {
      emit(MarcaError(e.toString()));
    }
  }

  Future<void> _onLoadMarcasProximasAVencer(
    LoadMarcasProximasAVencer event,
    Emitter<MarcaState> emit,
  ) async {
    try {
      final marcas = await _marcaRepository.getMarcasProximasAVencer(
        limit: event.limit,
      );

      emit(MarcasProximasAVencerLoaded(marcas: marcas));
    } catch (e) {
      emit(MarcaError(e.toString()));
    }
  }
}
