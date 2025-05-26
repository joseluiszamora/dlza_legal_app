import 'package:dlza_legal_app/core/components/custom_card.dart';
import 'package:dlza_legal_app/core/models/agency.dart';
import 'package:dlza_legal_app/views/agency/components/contrato_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AgencyDetailPage extends StatelessWidget {
  final Agency agency;

  const AgencyDetailPage({super.key, required this.agency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Agencia'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con nombre de la agencia
            _buildHeader(theme),

            const SizedBox(height: 24),

            // Información básica
            _buildInfoSection(
              context: context,
              title: 'Información Básica',
              children: [
                _buildInfoRow(
                  context: context,
                  label: 'Nombre',
                  value: agency.name,
                  icon: Icons.business,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Dirección',
                  value: agency.address.isNotEmpty ? agency.address : 'No especificada',
                  icon: Icons.location_on,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Ciudad',
                  value: agency.city,
                  icon: Icons.location_city,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'NIT',
                  value: agency.nitAgencia ?? 'No especificado',
                  icon: Icons.badge,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Información del agente
            _buildInfoSection(
              context: context,
              title: 'Información del Agente',
              children: [
                _buildInfoRow(
                  context: context,
                  label: 'Agente',
                  value: agency.agent,
                  icon: Icons.person,
                ),
                if (agency.agenteTelefono != null && agency.agenteTelefono!.isNotEmpty)
                  _buildContactRow(
                    context: context,
                    label: 'Teléfono',
                    value: agency.agenteTelefono!,
                    icon: Icons.phone,
                    onTap: () => _makePhoneCall(agency.agenteTelefono!),
                  ),
                if (agency.agenteEmail != null && agency.agenteEmail!.isNotEmpty)
                  _buildContactRow(
                    context: context,
                    label: 'Email',
                    value: agency.agenteEmail!,
                    icon: Icons.email,
                    onTap: () => _sendEmail(agency.agenteEmail!),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Información del contrato vigente
            _buildInfoSection(
              context: context,
              title: 'Contrato Vigente',
              children: [
                _buildInfoRow(
                  context: context,
                  label: 'Código de Contrato',
                  value: agency.codigoContratoVigente,
                  icon: Icons.description,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Inicio del Contrato',
                  value: agency.contratoInicioFormatted,
                  icon: Icons.play_arrow,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Fin del Contrato',
                  value: agency.contratoFinFormatted,
                  icon: Icons.stop,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Estado',
                  value: agency.estadoContrato,
                  icon: Icons.info,
                  valueColor: _getEstadoColor(agency.estadoContrato),
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Días Restantes',
                  value: agency.remainingTime,
                  icon: Icons.timer,
                  valueColor: _getTimerColor(agency.diasParaVencimiento),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Información de garantía
            _buildInfoSection(
              context: context,
              title: 'Garantía',
              children: [
                _buildInfoRow(
                  context: context,
                  label: 'Tipo de Garantía',
                  value: agency.tipoGarantiaVigente,
                  icon: Icons.security,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Monto de Garantía',
                  value: agency.formattedMontoGarantia,
                  icon: Icons.attach_money,
                  valueColor: theme.colorScheme.primary,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Licencia de funcionamiento
            _buildInfoSection(
              context: context,
              title: 'Licencia de Funcionamiento',
              children: [
                _buildInfoRow(
                  context: context,
                  label: 'Estado',
                  value: agency.licenciaDeFuncionamiento == true ? 'Vigente' : 'No vigente',
                  icon: Icons.verified,
                  valueColor: agency.licenciaDeFuncionamiento == true 
                      ? Colors.green 
                      : Colors.red,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Vigencia',
                  value: agency.vigenciaLicenciaFuncionamientoFormatted,
                  icon: Icons.calendar_today,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Tiempo Restante',
                  value: agency.remainingTimeLicenciaFuncionamiento,
                  icon: Icons.timer_outlined,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Observaciones
            if (agency.observaciones != null && agency.observaciones!.isNotEmpty)
              _buildInfoSection(
                context: context,
                title: 'Observaciones',
                children: [
                  _buildInfoRow(
                    context: context,
                    label: 'Notas',
                    value: agency.observaciones!,
                    icon: Icons.note,
                    isMultiline: true,
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // Lista de contratos
            _buildContractsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icono de la agencia
        Hero(
          tag: 'agency-${agency.id}',
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              Icons.business,
              size: 40,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                agency.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getEstadoColor(agency.estadoContrato).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  agency.estadoContrato,
                  style: TextStyle(
                    color: _getEstadoColor(agency.estadoContrato),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    agency.agent,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
    bool isMultiline = false,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 20,
            color: theme.colorScheme.secondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: valueColor ?? theme.colorScheme.onSurface,
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

  Widget _buildContactRow({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContractsSection(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description,
                size: 24,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Historial de Contratos',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${agency.contratos?.length ?? 0}',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (agency.contratos == null || agency.contratos!.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No hay contratos registrados',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: agency.contratos!.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final contrato = agency.contratos![index];
                return ContratoCard(contrato: contrato);
              },
            ),
        ],
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'vigente':
        return Colors.green;
      case 'por vencer':
        return Colors.orange;
      case 'vencido':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getTimerColor(int dias) {
    if (dias == 0) return Colors.red;
    if (dias <= 30) return Colors.orange;
    return Colors.green;
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  void _sendEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }
}
