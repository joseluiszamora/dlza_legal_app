import 'package:dlza_legal_app/core/models/marca.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RenovacionCard extends StatelessWidget {
  final RenovacionMarca renovacion;

  const RenovacionCard({super.key, required this.renovacion});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con estado y número
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getEstadoColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getEstadoColor()),
                ),
                child: Text(
                  renovacion.estadoRenovacion.toUpperCase(),
                  style: TextStyle(
                    color: _getEstadoColor(),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (renovacion.numeroDeRenovacion?.isNotEmpty == true)
                Text(
                  'N° ${renovacion.numeroDeRenovacion}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Información principal
          _buildInfoRow(
            'Solicitud',
            renovacion.numeroDeSolicitud,
            Icons.description,
          ),
          const SizedBox(height: 8),

          if (renovacion.fechaParaRenovacion != null)
            _buildInfoRow(
              'Fecha Renovación',
              DateFormat('dd/MM/yyyy').format(renovacion.fechaParaRenovacion!),
              Icons.calendar_today,
            ),

          const SizedBox(height: 8),
          _buildInfoRow('Titular', renovacion.titular, Icons.person),

          const SizedBox(height: 8),
          _buildInfoRow(
            'Apoderado',
            renovacion.apoderado,
            Icons.account_circle,
          ),

          if (renovacion.procesoSeguidoPor?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              'Proceso a cargo de',
              renovacion.procesoSeguidoPor!,
              Icons.assignment_ind,
            ),
          ],

          const SizedBox(height: 12),
          // Fecha de creación
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                'Registrado: ${DateFormat('dd/MM/yyyy HH:mm').format(renovacion.createdAt)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _getEstadoColor() {
    switch (renovacion.estadoRenovacion.toLowerCase()) {
      case 'registrada':
        return Colors.blue;
      case 'vigente':
        return Colors.green;
      case 'renovada':
        return Colors.orange;
      case 'caducada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
