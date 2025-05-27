import 'package:dlza_legal_app/core/models/marca.dart';
import 'package:dlza_legal_app/core/repositories/marca_repository.dart';
import 'package:dlza_legal_app/core/constants/app_colors.dart';
import 'package:dlza_legal_app/views/marca/components/renovacion_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MarcaDetailPage extends StatefulWidget {
  final int marcaId;

  const MarcaDetailPage({super.key, required this.marcaId});

  @override
  State<MarcaDetailPage> createState() => _MarcaDetailPageState();
}

class _MarcaDetailPageState extends State<MarcaDetailPage> {
  final MarcaRepository _marcaRepository = MarcaRepository();
  Marca? _marca;
  List<RenovacionMarca>? _renovaciones;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMarcaDetails();
  }

  Future<void> _loadMarcaDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final marca = await _marcaRepository.getMarcaById(widget.marcaId);
      final renovaciones = await _marcaRepository.getRenovacionesByMarcaId(
        widget.marcaId,
      );

      setState(() {
        _marca = marca;
        _renovaciones = renovaciones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_marca?.nombre ?? 'Detalles de Marca'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? _buildErrorWidget()
              : _marca != null
              ? _buildMarcaDetails()
              : const Center(child: Text('Marca no encontrada')),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            'Error al cargar la marca',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadMarcaDetails,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildMarcaDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMarcaHeader(),
          const SizedBox(height: 24),
          _buildMarcaInfo(),
          const SizedBox(height: 24),
          _buildRenovacionesSection(),
        ],
      ),
    );
  }

  Widget _buildMarcaHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                // Logo de la marca
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child:
                      _marca!.logotipoUrl?.isNotEmpty == true
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              _marca!.logotipoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => const Icon(
                                    Icons.image_not_supported,
                                    size: 40,
                                  ),
                            ),
                          )
                          : const Icon(
                            Icons.business,
                            size: 40,
                            color: AppColors.primary,
                          ),
                ),
                const SizedBox(width: 20),
                // Información principal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _marca!.nombre,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _marca!.getEstadoColor().withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _marca!.getEstadoColor()),
                        ),
                        child: Text(
                          _marca!.estado.toUpperCase(),
                          style: TextStyle(
                            color: _marca!.getEstadoColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Vence en: ${_marca!.getTiempoRestanteRenovacion()}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _getTiempoRestanteColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarcaInfo() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información Detallada',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Número de Registro', _marca!.numeroRegistro),
            _buildDetailRow('Género', _marca!.genero),
            _buildDetailRow('Tipo', _marca!.tipo),
            _buildDetailRow('Clase Niza', _marca!.claseNiza),
            _buildDetailRow(
              'Fecha de Registro',
              DateFormat('dd/MM/yyyy').format(_marca!.fechaRegistro),
            ),
            if (_marca!.fechaExpiracionRegistro != null)
              _buildDetailRow(
                'Fecha de Expiración',
                DateFormat(
                  'dd/MM/yyyy',
                ).format(_marca!.fechaExpiracionRegistro!),
              ),
            if (_marca!.fechaLimiteRenovacion != null)
              _buildDetailRow(
                'Fecha Límite Renovación',
                DateFormat('dd/MM/yyyy').format(_marca!.fechaLimiteRenovacion!),
              ),
            _buildDetailRow('Titular', _marca!.titular),
            _buildDetailRow('Apoderado', _marca!.apoderado),
            if (_marca!.tramiteArealizar?.isNotEmpty == true)
              _buildDetailRow('Trámite a Realizar', _marca!.tramiteArealizar!),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRenovacionesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Historial de Renovaciones',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_renovaciones?.isEmpty ?? true)
              Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      'No hay renovaciones registradas',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _renovaciones!.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return RenovacionCard(renovacion: _renovaciones![index]);
                },
              ),
          ],
        ),
      ),
    );
  }

  Color _getTiempoRestanteColor() {
    if (_marca!.fechaLimiteRenovacion == null) return Colors.grey;

    final now = DateTime.now();
    final diferencia = _marca!.fechaLimiteRenovacion!.difference(now);

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
