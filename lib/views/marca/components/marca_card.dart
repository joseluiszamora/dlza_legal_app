import 'package:dlza_legal_app/core/models/marca.dart';
import 'package:dlza_legal_app/core/constants/app_colors.dart';
import 'package:dlza_legal_app/views/marca/marca_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarcaCard extends StatelessWidget {
  final Marca marca;

  const MarcaCard({super.key, required this.marca});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MarcaDetailPage(marcaId: marca.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Logo de la marca
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                    ),
                    child:
                        marca.logotipoUrl?.isNotEmpty == true
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                marca.logotipoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Icon(Icons.image_not_supported),
                              ),
                            )
                            : const Icon(
                              Icons.business,
                              size: 30,
                              color: AppColors.primary,
                            ),
                  ),
                  const SizedBox(width: 16),
                  // Información principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          marca.nombre,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: marca.getEstadoColor().withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: marca.getEstadoColor(),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                marca.estado.toUpperCase(),
                                style: TextStyle(
                                  color: marca.getEstadoColor(),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              marca.tipo,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Tiempo restante
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: _getTiempoRestanteColor(),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        marca.getTiempoRestanteRenovacion(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getTiempoRestanteColor(),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Información adicional
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      'Registro',
                      marca.numeroRegistro,
                      Icons.confirmation_number,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      'Clase Niza',
                      marca.claseNiza,
                      Icons.category,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      'Fecha Registro',
                      DateFormat('dd/MM/yyyy').format(marca.fechaRegistro),
                      Icons.calendar_today,
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      'Vencimiento',
                      marca.fechaExpiracionRegistro != null
                          ? DateFormat(
                            'dd/MM/yyyy',
                          ).format(marca.fechaExpiracionRegistro!)
                          : 'Sin fecha',
                      Icons.event_busy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Titular y Apoderado
              _buildInfoItem('Titular', marca.titular, Icons.person),
              const SizedBox(height: 8),
              _buildInfoItem(
                'Apoderado',
                marca.apoderado,
                Icons.account_circle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getTiempoRestanteColor() {
    if (marca.fechaLimiteRenovacion == null) return Colors.grey;

    final now = DateTime.now();
    final diferencia = marca.fechaLimiteRenovacion!.difference(now);

    if (diferencia.isNegative) {
      return Colors.red;
    } else if (diferencia.inDays <= 30) {
      return Colors.orange;
    } else if (diferencia.inDays <= 90) {
      return Colors.yellow[700] ?? Colors.yellow;
    } else {
      return Colors.green;
    }
  }
}
