import 'package:dlza_legal_app/core/components/custom_card.dart';
import 'package:dlza_legal_app/core/models/agency.dart';
import 'package:dlza_legal_app/views/agency/agency_detail.dart';
import 'package:flutter/material.dart';

class AgencyCard extends StatelessWidget {
  final Agency agency;

  const AgencyCard({super.key, required this.agency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AgencyDetail(agencyId: agency.id),
          ),
        );
      },
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre de la agencia con badge de ciudad
          Row(
            children: [
              Expanded(
                child: Text(
                  agency.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.secondary,
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
                  agency.city,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Información del agente
          Row(
            children: [
              Icon(
                Icons.person,
                size: 16,
                color:
                    theme.brightness == Brightness.light
                        ? Colors.black54
                        : Colors.white70,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Agente: ${agency.agent}',
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: const Divider(height: 24, color: Colors.black26),
          ),

          // Información de garantía
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tipo de Garantía',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.brightness == Brightness.light
                                ? Colors.black54
                                : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      agency.tipoGarantia,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monto de Garantía',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.brightness == Brightness.light
                                ? Colors.black54
                                : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      agency.formattedMontoGarantia,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Información del contrato
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fin de Contrato',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.brightness == Brightness.light
                                ? Colors.black54
                                : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      agency.contratoFinFormatted,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _buildRemainingTime(context, agency.remainingTime),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingTime(BuildContext context, String remainingTime) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              remainingTime,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
