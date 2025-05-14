import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dlza_legal_app/core/blocs/agency/agency_bloc.dart';
import 'package:dlza_legal_app/core/models/agency.dart';

class AgencyDetail extends StatelessWidget {
  final int agencyId;

  const AgencyDetail({super.key, required this.agencyId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AgencyBloc()..add(LoadAgencyDetails(agencyId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalles de Agencia'),
          actions: [
            BlocBuilder<AgencyBloc, AgencyState>(
              builder: (context, state) {
                if (state is AgencyDetailLoaded) {
                  final agency = state.agency;
                  if (agency.latitud != null && agency.longitud != null) {
                    return TextButton.icon(
                      icon: const Icon(Icons.map, color: Colors.white),
                      label: const Text(
                        'Ver en mapa',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => _openInMap(agency),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<AgencyBloc, AgencyState>(
          builder: (context, state) {
            if (state is AgencyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AgencyError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is AgencyDetailLoaded) {
              return _buildAgencyDetails(context, state.agency);
            }
            return const Center(child: Text('No se encontró la agencia'));
          },
        ),
      ),
    );
  }

  Widget _buildAgencyDetails(BuildContext context, Agency agency) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con nombre de la agencia y ciudad
          Text(
            agency.name,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8.0),

          Text(
            agency.city,
            style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
          ),

          const Divider(height: 32.0),

          // Información de contacto y ubicación
          _buildSectionTitle('Información de Contacto'),

          _buildDetailRow('Agente', agency.agent, Icons.person),
          _buildDetailRow('Dirección', agency.address, Icons.location_on),

          const SizedBox(height: 24.0),

          // Información del contrato
          _buildSectionTitle('Información del Contrato'),

          _buildDetailRow(
            'Tipo de Garantía',
            agency.tipoGarantia,
            Icons.security,
          ),
          _buildDetailRow(
            'Monto de Garantía',
            agency.formattedMontoGarantia,
            Icons.local_atm,
          ),
          _buildDetailRow(
            'Inicio de Contrato',
            agency.contratoInicioFormatted,
            Icons.calendar_today,
          ),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildDetailRow(
                  'Fin de Contrato',
                  agency.contratoFinFormatted,
                  Icons.event,
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: _getRemainingTimeColor(
                      agency.remainingTime,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getRemainingTimeIcon(agency.remainingTime),
                        color: _getRemainingTimeColor(agency.remainingTime),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          agency.remainingTime,
                          style: TextStyle(
                            color: _getRemainingTimeColor(agency.remainingTime),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const Divider(height: 32.0),

          // Documentos requeridos
          _buildSectionTitle('Documentos Disponibles'),

          _buildDocumentList(agency),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueGrey),
          const SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14.0, color: Colors.black54),
              ),
              const SizedBox(height: 4.0),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentList(Agency agency) {
    final documents = [
      {'name': 'Carnet de Identidad (CI)', 'available': agency.ci},
      {'name': 'Croquis', 'available': agency.croquis},
      {
        'name': 'Factura de Servicio Básico',
        'available': agency.facturaServicioBasico,
      },
      {'name': 'NIT', 'available': agency.nit},
      {
        'name': 'Licencia de Funcionamiento',
        'available': agency.licenciaDeFuncionamiento,
      },
      {'name': 'RUAT', 'available': agency.ruat},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final doc = documents[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color:
                  doc['available'] as bool
                      ? Colors.green
                      : Colors.red.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Icon(
                doc['available'] as bool ? Icons.check_circle : Icons.cancel,
                color:
                    doc['available'] as bool
                        ? Colors.green
                        : Colors.red.withOpacity(0.7),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  doc['name'] as String,
                  style: const TextStyle(fontSize: 12.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getRemainingTimeColor(String remainingTime) {
    if (remainingTime.contains('vencido')) {
      return Colors.red;
    } else if (remainingTime.contains('días')) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  IconData _getRemainingTimeIcon(String remainingTime) {
    if (remainingTime.contains('vencido')) {
      return Icons.warning;
    } else if (remainingTime.contains('días')) {
      return Icons.access_time;
    } else {
      return Icons.check_circle;
    }
  }

  Future<void> _openInMap(Agency agency) async {
    if (agency.latitud == null || agency.longitud == null) return;

    final url =
        'https://www.google.com/maps/search/?api=1&query=${agency.latitud},${agency.longitud}';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'No se pudo abrir el mapa';
    }
  }
}
