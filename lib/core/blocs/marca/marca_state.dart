part of 'marca_bloc.dart';

abstract class MarcaState extends Equatable {
  const MarcaState();

  @override
  List<Object?> get props => [];
}

class MarcaInitial extends MarcaState {}

class MarcaLoading extends MarcaState {}

class MarcaLoaded extends MarcaState {
  final List<Marca> marcas;
  final bool hasReachedMax;
  final int currentPage;
  final int totalItems;
  final String? searchQuery;

  const MarcaLoaded({
    required this.marcas,
    required this.hasReachedMax,
    required this.currentPage,
    required this.totalItems,
    this.searchQuery,
  });

  MarcaLoaded copyWith({
    List<Marca>? marcas,
    bool? hasReachedMax,
    int? currentPage,
    int? totalItems,
    String? searchQuery,
  }) {
    return MarcaLoaded(
      marcas: marcas ?? this.marcas,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    marcas,
    hasReachedMax,
    currentPage,
    totalItems,
    searchQuery,
  ];
}

class MarcaError extends MarcaState {
  final String message;

  const MarcaError(this.message);

  @override
  List<Object> get props => [message];
}

class MarcasProximasAVencerLoaded extends MarcaState {
  final List<Marca> marcas;

  const MarcasProximasAVencerLoaded({required this.marcas});

  @override
  List<Object> get props => [marcas];
}
