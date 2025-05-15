import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dlza_legal_app/core/blocs/agency/agency_bloc.dart';
import 'package:dlza_legal_app/core/models/agency.dart';
import 'package:dlza_legal_app/core/components/primary_button.dart';
import 'package:dlza_legal_app/core/components/custom_card.dart';
import 'package:dlza_legal_app/core/components/section_header.dart';

class AgencyDetail extends StatelessWidget {
  final int agencyId;

  const AgencyDetail({super.key, required this.agencyId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => AgencyBloc()..add(LoadAgencyDetails(agencyId)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: BlocBuilder<AgencyBloc, AgencyState>(
              builder: (context, state) {
                if (state is AgencyLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AgencyError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text('Error: ${state.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Volver'),
                        ),
                      ],
                    ),
                  );
                } else if (state is AgencyDetailLoaded) {
                  final agency = state.agency;
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: 120,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text(
                            agency.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          background: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.primary.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                        ),
                        actions: [
                          if (agency.latitud != null && agency.longitud != null)
                            IconButton(
                              icon: const Icon(Icons.map),
                              tooltip: 'Ver en mapa',
                              onPressed: () => _openInMap(agency),
                            ),
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: _buildAgencyDetails(context, agency),
                      ),
                    ],
                  );
                }
                return const Center(child: Text('No se encontró la agencia'));
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAgencyDetails(BuildContext context, Agency agency) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con ciudad y badge de estado del contrato
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_city,
                      size: 16,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      agency.city,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (agency.latitud != null && agency.longitud != null)
                PrimaryButton(
                  text: 'Ver en mapa',
                  icon: Icons.map,
                  width: 150,
                  onPressed: () => _openInMap(agency),
                ),
            ],
          ),

          const SizedBox(height: 24),

          // Información de contacto y ubicación
          _buildInfoSection(context, 'Información de Contacto', [
            _buildInfoItem(context, 'Agente', agency.agent, Icons.person),
            _buildInfoItem(
              context,
              'Dirección',
              agency.address,
              Icons.location_on,
            ),
          ]),

          const SizedBox(height: 20),

          // Información del contrato
          _buildInfoSection(context, 'Información del Contrato', [
            _buildInfoItem(
              context,
              'Tipo de Garantía',
              agency.tipoGarantia,
              Icons.security,
            ),
            _buildInfoItem(
              context,
              'Monto de Garantía',
              agency.formattedMontoGarantia,
              Icons.attach_money,
            ),
            _buildInfoItem(
              context,
              'Inicio de Contrato',
              agency.contratoInicioFormatted,
              Icons.calendar_today,
            ),
            // Fin de contrato con tiempo restante
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildInfoItem(
                    context,
                    'Fin de Contrato',
                    agency.contratoFinFormatted,
                    Icons.event,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: _buildRemainingTimeItem(context, agency.remainingTime),
                ),
              ],
            ),
          ]),

          const SizedBox(height: 20),

          // Documentos disponibles
          _buildInfoSection(context, 'Documentos Disponibles', [
            _buildDocumentList(context, agency),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        theme.brightness == Brightness.light
                            ? Colors.black54
                            : Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingTimeItem(BuildContext context, String remainingTime) {
    Color color;
    IconData icon;

    if (remainingTime.contains('vencido')) {
      color = Colors.red;
      icon = Icons.warning;
    } else if (remainingTime.contains('días')) {
      color = Colors.orange;
      icon = Icons.access_time;
    } else {
      color = Colors.green;
      icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              remainingTime,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentList(BuildContext context, Agency agency) {
    final theme = Theme.of(context);
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
        final isAvailable = doc['available'] as bool;

        return Container(
          decoration: BoxDecoration(
            color:
                isAvailable
                    ? theme.colorScheme.primary.withOpacity(0.05)
                    : theme.brightness == Brightness.light
                    ? Colors.grey.shade100
                    : Colors.grey.shade800,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isAvailable
                      ? theme.colorScheme.primary
                      : theme.brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade700,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      isAvailable
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : theme.brightness == Brightness.light
                          ? Colors.grey.shade200
                          : Colors.grey.shade700,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isAvailable ? Icons.check_circle : Icons.cancel,
                  color:
                      isAvailable
                          ? theme.colorScheme.primary
                          : theme.brightness == Brightness.light
                          ? Colors.grey
                          : Colors.grey.shade500,
                  size: 20,
                ),
              ),
              Expanded(
                child: Text(
                  doc['name'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isAvailable ? FontWeight.w500 : FontWeight.normal,
                    color:
                        isAvailable
                            ? null
                            : theme.brightness == Brightness.light
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        );
      },
    );
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
