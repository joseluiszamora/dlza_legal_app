import 'package:dlza_legal_app/core/blocs/marca/marca_bloc.dart';
import 'package:dlza_legal_app/core/models/marca.dart';
import 'package:dlza_legal_app/core/constants/app_colors.dart';
import 'package:dlza_legal_app/views/marca/marca_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BrandsExpirationList extends StatelessWidget {
  const BrandsExpirationList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MarcaBloc()..add(const LoadMarcasProximasAVencer()),
      child: BlocBuilder<MarcaBloc, MarcaState>(
        builder: (context, state) {
          if (state is MarcaLoading || state is MarcaInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MarcaError) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                  const SizedBox(height: 8),
                  Text(
                    'Error al cargar marcas próximas a vencer',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is MarcasProximasAVencerLoaded) {
            if (state.marcas.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Colors.green[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No hay marcas próximas a vencer',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Column(
              children:
                  state.marcas
                      .map((marca) => _BrandExpirationCard(marca: marca))
                      .toList(),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _BrandExpirationCard extends StatelessWidget {
  final Marca marca;

  const _BrandExpirationCard({required this.marca});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final diasRestantes = _getDiasRestantes();
    final tiempoRestante = _getTiempoRestanteFormateado();
    final color = _getColorPorDiasRestantes(diasRestantes);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MarcaDetailPage(marcaId: marca.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Logo de la marca
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.grey[200],
                ),
                child:
                    marca.logotipoUrl?.isNotEmpty == true
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            marca.logotipoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.business, size: 20),
                          ),
                        )
                        : const Icon(
                          Icons.business,
                          size: 20,
                          color: AppColors.primary,
                        ),
              ),
              const SizedBox(width: 12),
              // Información de la marca
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marca.nombre,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Vence: ${marca.fechaExpiracionRegistro != null ? DateFormat('dd/MM/yyyy').format(marca.fechaExpiracionRegistro!) : 'N/A'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Tiempo restante
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color, width: 1),
                ),
                child: Text(
                  tiempoRestante,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getDiasRestantes() {
    if (marca.fechaExpiracionRegistro == null) return 0;
    final ahora = DateTime.now();
    final fechaExpiracion = marca.fechaExpiracionRegistro!;
    return fechaExpiracion.difference(ahora).inDays;
  }

  String _getTiempoRestanteFormateado() {
    final dias = _getDiasRestantes();

    if (dias < 0) {
      return 'Vencida';
    } else if (dias == 0) {
      return 'Hoy';
    } else if (dias == 1) {
      return '1 día';
    } else if (dias < 30) {
      return '$dias días';
    } else if (dias < 90) {
      final meses = (dias / 30).round();
      return meses == 1 ? '1 mes' : '$meses meses';
    } else {
      return '+90 días';
    }
  }

  Color _getColorPorDiasRestantes(int dias) {
    if (dias < 0) {
      return Colors.red;
    } else if (dias <= 15) {
      return Colors.red;
    } else if (dias <= 30) {
      return Colors.orange;
    } else if (dias <= 60) {
      return Colors.yellow[700] ?? Colors.yellow;
    } else {
      return Colors.green;
    }
  }
}
