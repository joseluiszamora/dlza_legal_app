part of 'marca_bloc.dart';

abstract class MarcaEvent extends Equatable {
  const MarcaEvent();

  @override
  List<Object?> get props => [];
}

class LoadMarcas extends MarcaEvent {
  final String? searchQuery;

  const LoadMarcas({this.searchQuery});

  @override
  List<Object?> get props => [searchQuery];
}

class LoadMoreMarcas extends MarcaEvent {}

class SearchMarcas extends MarcaEvent {
  final String query;

  const SearchMarcas(this.query);

  @override
  List<Object> get props => [query];
}

class RefreshMarcas extends MarcaEvent {}
