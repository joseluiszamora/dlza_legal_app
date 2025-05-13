part of 'agency_bloc.dart';

abstract class AgencyState extends Equatable {
  const AgencyState();

  @override
  List<Object> get props => [];
}

// Estado inicial/cargando
class AgencyLoading extends AgencyState {}

// Estado cargado con datos
class AgencyLoaded extends AgencyState {
  final List<Agency> agencies;

  const AgencyLoaded({required this.agencies});

  @override
  List<Object> get props => [agencies];
}

class AgencyDetailLoaded extends AgencyState {
  final Agency agency;

  const AgencyDetailLoaded(this.agency);

  @override
  List<Object> get props => [agency];
}

// Estado de error
class AgencyError extends AgencyState {
  final String message;

  const AgencyError(this.message);

  @override
  List<Object> get props => [message];
}
