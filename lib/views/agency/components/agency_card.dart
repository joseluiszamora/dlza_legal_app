import 'package:dlza_legal_app/core/models/agency.dart';
import 'package:dlza_legal_app/views/agency/agency_detail.dart';
import 'package:flutter/material.dart';

class AgencyCard extends StatelessWidget {
  final Agency agency;

  const AgencyCard({super.key, required this.agency});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgencyDetail(agencyId: agency.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                agency.name,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              _buildInfoRow(
                icon: Icons.person,
                text: 'Agente: ${agency.agent}',
              ),
              _buildInfoRow(
                icon: Icons.location_city,
                text: 'Ciudad: ${agency.city}',
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.local_atm,
                      text: 'Garantía: ${agency.formattedMontoGarantia}',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.security,
                      text: 'Tipo: ${agency.tipoGarantia}',
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.calendar_today,
                      text: 'Fin de contrato: ${agency.contratoFinFormatted}',
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildRemainingTime(agency.remainingTime),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingTime(String remainingTime) {
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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4.0),
          Expanded(
            child: Text(
              remainingTime,
              style: TextStyle(fontSize: 12.0, color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
