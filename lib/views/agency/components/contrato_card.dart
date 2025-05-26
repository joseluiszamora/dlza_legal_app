import 'package:dlza_legal_app/core/models/agency.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContratoCard extends StatelessWidget {
  final ContratoAgencia contrato;

  const ContratoCard({super.key, required this.contrato});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: contrato.activo 
            ? theme.colorScheme.primary.withOpacity(0.05)
            : theme.colorScheme.surface,
        border: Border.all(
          color: contrato.activo 
              ? theme.colorScheme.primary.withOpacity(0.3)
              : theme.colorScheme.outline.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header del contrato
          Row(
            children: [
              Expanded(
                child: Text(
                  contrato.codigoContrato,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: contrato.activo 
                        ? theme.colorScheme.primary 
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (contrato.activo)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ACTIVO',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getEstadoColor(contrato.estado ?? 'vigente').withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  (contrato.estado ?? 'vigente').toUpperCase(),
                  style: TextStyle(
                    color: _getEstadoColor(contrato.estado ?? 'vigente'),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Información del contrato
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Inicio',
                  contrato.contratoInicio != null
                      ? DateFormat('dd/MM/yyyy').format(contrato.contratoInicio!)
                      : 'No especificado',
                  Icons.play_arrow,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Fin',
                  contrato.contratoFin != null
                      ? DateFormat('dd/MM/yyyy').format(contrato.contratoFin!)
                      : 'No especificado',
                  Icons.stop,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Garantía
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Tipo Garantía',
                  contrato.tipoGarantia ?? 'No especificado',
                  Icons.security,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoItem(
                  context,
                  'Monto Garantía',
                  contrato.formattedMontoGarantia,
                  Icons.attach_money,
                  valueColor: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          
          // Testimonio notarial (si existe)
          if (contrato.testimonioNotarial != null && contrato.testimonioNotarial!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildInfoItem(
              context,
              'Testimonio Notarial',
              contrato.testimonioNotarial!,
              Icons.assignment,
            ),
          ],
          
          // Observaciones (si existen)
          if (contrato.observaciones != null && contrato.observaciones!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildInfoItem(
              context,
              'Observaciones',
              contrato.observaciones!,
              Icons.note,
              isMultiline: true,
            ),
          ],
          
          // Días restantes (solo para contratos activos con fecha de fin)
          if (contrato.activo && contrato.contratoFin != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getTimerBackgroundColor(contrato.contratoFin!),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 16,
                    color: _getTimerColor(contrato.contratoFin!),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Vence en: ${_getRemainingTime(contrato.contratoFin!)}',
                    style: TextStyle(
                      color: _getTimerColor(contrato.contratoFin!),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
    bool isMultiline = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 14,
          color: theme.colorScheme.secondary,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 11,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: valueColor ?? theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                maxLines: isMultiline ? null : 1,
                overflow: isMultiline ? null : TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
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
      case 'finalizado':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Color _getTimerColor(DateTime fechaFin) {
    final ahora = DateTime.now();
    final diferencia = fechaFin.difference(ahora).inDays;
    
    if (diferencia <= 0) return Colors.red.shade700;
    if (diferencia <= 30) return Colors.orange.shade700;
    return Colors.green.shade700;
  }

  Color _getTimerBackgroundColor(DateTime fechaFin) {
    final ahora = DateTime.now();
    final diferencia = fechaFin.difference(ahora).inDays;
    
    if (diferencia <= 0) return Colors.red.withOpacity(0.1);
    if (diferencia <= 30) return Colors.orange.withOpacity(0.1);
    return Colors.green.withOpacity(0.1);
  }

  String _getRemainingTime(DateTime fechaFin) {
    final ahora = DateTime.now();
    final diferencia = fechaFin.difference(ahora).inDays;
    
    if (diferencia <= 0) return 'Vencido';
    if (diferencia == 1) return '1 día';
    if (diferencia < 30) return '$diferencia días';
    if (diferencia < 365) {
      final meses = (diferencia / 30).round();
      return meses == 1 ? '1 mes' : '$meses meses';
    } else {
      final anios = (diferencia / 365).round();
      return anios == 1 ? '1 año' : '$anios años';
    }
  }
}
