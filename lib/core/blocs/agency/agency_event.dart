part of 'agency_bloc.dart';

abstract class AgencyEvent extends Equatable {
  const AgencyEvent();

  @override
  List<Object> get props => [];
}

// Evento para cargar las agencias
class LoadAgencies extends AgencyEvent {
  const LoadAgencies();

  @override
  List<Object> get props => [];
}

class LoadAgencyDetails extends AgencyEvent {
  final String agencyId;

  const LoadAgencyDetails(this.agencyId);

  @override
  List<Object> get props => [agencyId];
}
