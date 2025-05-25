import 'package:flutter/material.dart';

class Marca {
  final int id;
  final String nombre;
  final String estado; // registrada|vigente|renovada|caducada
  final String? logotipoUrl;
  final String genero; // marca producto|marca servicio|lema comercial
  final String
  tipo; // mixta|figurativa|nominativa|denominacion|tridimensional|sonora|olfativa
  final String claseNiza;
  final String numeroRegistro;
  final DateTime fechaRegistro;
  final String? tramiteArealizar;
  final DateTime? fechaExpiracionRegistro;
  final DateTime? fechaLimiteRenovacion;
  final String titular;
  final String apoderado;
  final DateTime createdAt;
  final List<RenovacionMarca>? renovaciones;

  const Marca({
    required this.id,
    required this.nombre,
    required this.estado,
    this.logotipoUrl,
    required this.genero,
    required this.tipo,
    required this.claseNiza,
    required this.numeroRegistro,
    required this.fechaRegistro,
    this.tramiteArealizar,
    this.fechaExpiracionRegistro,
    this.fechaLimiteRenovacion,
    required this.titular,
    required this.apoderado,
    required this.createdAt,
    this.renovaciones,
  });

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      estado: json['estado'] as String,
      logotipoUrl: json['logotipoUrl'] as String?,
      genero: json['genero'] as String,
      tipo: json['tipo'] as String,
      claseNiza: json['claseNiza'] as String,
      numeroRegistro: json['numeroRegistro'] as String,
      fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
      tramiteArealizar: json['tramiteArealizar'] as String?,
      fechaExpiracionRegistro:
          json['fechaExpiracionRegistro'] != null
              ? DateTime.parse(json['fechaExpiracionRegistro'] as String)
              : null,
      fechaLimiteRenovacion:
          json['fechaLimiteRenovacion'] != null
              ? DateTime.parse(json['fechaLimiteRenovacion'] as String)
              : null,
      titular: json['titular'] as String,
      apoderado: json['apoderado'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      renovaciones:
          json['renovaciones'] != null
              ? (json['renovaciones'] as List)
                  .map((e) => RenovacionMarca.fromJson(e))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'estado': estado,
      'logotipoUrl': logotipoUrl,
      'genero': genero,
      'tipo': tipo,
      'claseNiza': claseNiza,
      'numeroRegistro': numeroRegistro,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'tramiteArealizar': tramiteArealizar,
      'fechaExpiracionRegistro': fechaExpiracionRegistro?.toIso8601String(),
      'fechaLimiteRenovacion': fechaLimiteRenovacion?.toIso8601String(),
      'titular': titular,
      'apoderado': apoderado,
      'createdAt': createdAt.toIso8601String(),
      'renovaciones': renovaciones?.map((e) => e.toJson()).toList(),
    };
  }

  /// Calcula el tiempo restante hasta la fecha límite de renovación
  String getTiempoRestanteRenovacion() {
    if (fechaLimiteRenovacion == null) return 'Sin fecha límite';

    final now = DateTime.now();
    final diferencia = fechaLimiteRenovacion!.difference(now);

    if (diferencia.isNegative) {
      return 'Vencida';
    }

    final dias = diferencia.inDays;
    if (dias == 0) {
      return 'Hoy';
    } else if (dias == 1) {
      return '1 día';
    } else if (dias < 30) {
      return '$dias días';
    } else if (dias < 365) {
      final meses = (dias / 30).round();
      return meses == 1 ? '1 mes' : '$meses meses';
    } else {
      final anos = (dias / 365).round();
      return anos == 1 ? '1 año' : '$anos años';
    }
  }

  /// Obtiene el color según el estado de la marca
  Color getEstadoColor() {
    switch (estado.toLowerCase()) {
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

class RenovacionMarca {
  final int id;
  final String estadoRenovacion; // registrada|vigente|renovada|caducada
  final String? numeroDeRenovacion;
  final DateTime? fechaParaRenovacion;
  final String numeroDeSolicitud;
  final String titular;
  final String apoderado;
  final String? procesoSeguidoPor;
  final DateTime createdAt;
  final int marcaId;

  const RenovacionMarca({
    required this.id,
    required this.estadoRenovacion,
    this.numeroDeRenovacion,
    this.fechaParaRenovacion,
    required this.numeroDeSolicitud,
    required this.titular,
    required this.apoderado,
    this.procesoSeguidoPor,
    required this.createdAt,
    required this.marcaId,
  });

  factory RenovacionMarca.fromJson(Map<String, dynamic> json) {
    return RenovacionMarca(
      id: json['id'] as int,
      estadoRenovacion: json['estadoRenovacion'] as String,
      numeroDeRenovacion: json['numeroDeRenovacion'] as String?,
      fechaParaRenovacion:
          json['fechaParaRenovacion'] != null
              ? DateTime.parse(json['fechaParaRenovacion'] as String)
              : null,
      numeroDeSolicitud: json['numeroDeSolicitud'] as String,
      titular: json['titular'] as String,
      apoderado: json['apoderado'] as String,
      procesoSeguidoPor: json['procesoSeguidoPor'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      marcaId: json['marcaId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'estadoRenovacion': estadoRenovacion,
      'numeroDeRenovacion': numeroDeRenovacion,
      'fechaParaRenovacion': fechaParaRenovacion?.toIso8601String(),
      'numeroDeSolicitud': numeroDeSolicitud,
      'titular': titular,
      'apoderado': apoderado,
      'procesoSeguidoPor': procesoSeguidoPor,
      'createdAt': createdAt.toIso8601String(),
      'marcaId': marcaId,
    };
  }
}
