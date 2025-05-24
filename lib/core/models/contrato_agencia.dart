class ContratoAgencia {
  final int id;
  final int agenciaId;
  final String tipoContrato;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final double? monto;
  final String? observaciones;
  final DateTime createdAt;

  ContratoAgencia({
    required this.id,
    required this.agenciaId,
    required this.tipoContrato,
    required this.fechaInicio,
    this.fechaFin,
    this.monto,
    this.observaciones,
    required this.createdAt,
  });

  factory ContratoAgencia.fromJson(Map<String, dynamic> json) {
    return ContratoAgencia(
      id: json['id'] as int,
      agenciaId: json['agenciaId'] as int,
      tipoContrato: json['tipoContrato'] as String? ?? 'Sin tipo',
      fechaInicio:
          json['fechaInicio'] != null
              ? DateTime.parse(json['fechaInicio'] as String)
              : DateTime.now(),
      fechaFin:
          json['fechaFin'] != null
              ? DateTime.parse(json['fechaFin'] as String)
              : DateTime.now(),
      monto: (json['monto'] as num?)?.toDouble() ?? 0,
      observaciones: json['observaciones'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  bool get estaActivo => fechaFin == null || fechaFin!.isAfter(DateTime.now());
}
