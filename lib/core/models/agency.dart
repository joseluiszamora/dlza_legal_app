import 'package:intl/intl.dart';

// Modelo ContratoAgencia
class ContratoAgencia {
  final int id;
  final String codigoContrato;
  final DateTime? contratoInicio;
  final DateTime? contratoFin;
  final String? tipoGarantia;
  final double? montoGarantia;
  final String? testimonioNotarial;
  final String? estado;
  final String? observaciones;
  final bool activo;
  final DateTime createdAt;
  final int agenciaId;

  ContratoAgencia({
    required this.id,
    required this.codigoContrato,
    this.contratoInicio,
    this.contratoFin,
    this.tipoGarantia,
    this.montoGarantia,
    this.testimonioNotarial,
    this.estado,
    this.observaciones,
    required this.activo,
    required this.createdAt,
    required this.agenciaId,
  });

  factory ContratoAgencia.fromJson(Map<String, dynamic> json) {
    return ContratoAgencia(
      id: json['id'],
      codigoContrato: json['codigoContrato'] ?? '',
      contratoInicio: json['contratoInicio'] != null
          ? DateTime.parse(json['contratoInicio'])
          : null,
      contratoFin: json['contratoFin'] != null
          ? DateTime.parse(json['contratoFin'])
          : null,
      tipoGarantia: json['tipoGarantia'],
      montoGarantia: json['montoGarantia']?.toDouble(),
      testimonioNotarial: json['testimonioNotarial'],
      estado: json['estado'] ?? 'vigente',
      observaciones: json['observaciones'],
      activo: json['activo'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      agenciaId: json['agenciaId'],
    );
  }

  String get formattedMontoGarantia {
    if (montoGarantia == null || montoGarantia == 0) return 'Bs. 0';
    final formatter = NumberFormat.currency(
      locale: 'es_BO',
      symbol: 'Bs. ',
      decimalDigits: 0,
    );
    return formatter.format(montoGarantia);
  }
}

class Agency {
  final int id;
  final DateTime createdAt;
  final String? nombre;
  final String? direccion;
  final double? latitud;
  final double? longitud;
  final bool? licenciaDeFuncionamiento;
  final DateTime? vigenciaLicenciaFuncionamiento;
  final String codigoContratoVigente;
  final DateTime? inicioContratoVigente;
  final DateTime? finContratoVigente;
  final String? nitAgencia;
  final String? contratoAlquiler;
  final String? observaciones;
  final int agenteId;
  final int ciudadId;
  
  // Datos de relaciones
  final String? agenteNombres;
  final String? agenteApellidos;
  final String? agenteTelefono;
  final String? agenteEmail;
  final String? ciudadNombre;
  final String? ciudadPais;
  final List<ContratoAgencia>? contratos;

  Agency({
    required this.id,
    required this.createdAt,
    this.nombre,
    this.direccion,
    this.latitud,
    this.longitud,
    this.licenciaDeFuncionamiento,
    this.vigenciaLicenciaFuncionamiento,
    required this.codigoContratoVigente,
    this.inicioContratoVigente,
    this.finContratoVigente,
    this.nitAgencia,
    this.contratoAlquiler,
    required    this.observaciones,
    required this.agenteId,
    required this.ciudadId,
    // Datos de relaciones
    this.agenteNombres,
    this.agenteApellidos,
    this.agenteTelefono,
    this.agenteEmail,
    this.ciudadNombre,
    this.ciudadPais,
    this.contratos,
  });

  factory Agency.fromJson(Map<String, dynamic> json) {
    return Agency(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      nombre: json['nombre'],
      direccion: json['direccion'],
      latitud: json['latitud']?.toDouble(),
      longitud: json['longitud']?.toDouble(),
      licenciaDeFuncionamiento: json['licenciaDeFuncionamiento'],
      vigenciaLicenciaFuncionamiento: json['vigenciaLicenciaFuncionamiento'] != null
          ? DateTime.parse(json['vigenciaLicenciaFuncionamiento'])
          : null,
      codigoContratoVigente: json['codigoContratoVigente'] ?? '0',
      inicioContratoVigente: json['inicioContratoVigente'] != null
          ? DateTime.parse(json['inicioContratoVigente'])
          : null,
      finContratoVigente: json['finContratoVigente'] != null
          ? DateTime.parse(json['finContratoVigente'])
          : null,
      nitAgencia: json['nitAgencia'],
      contratoAlquiler: json['contratoAlquiler'],
      observaciones: json['observaciones'],
      agenteId: json['agenteId'] ?? 1,
      ciudadId: json['ciudadId'] ?? 1,
      agenteNombres: json['agente']?['nombres'],
      agenteApellidos: json['agente']?['apellidos'],
      agenteTelefono: json['agente']?['telefono'],
      agenteEmail: json['agente']?['email'],
      ciudadNombre: json['ciudad']?['nombre'],
      ciudadPais: json['ciudad']?['pais'],
      contratos: json['contratos'] != null
          ? (json['contratos'] as List)
              .map((c) => ContratoAgencia.fromJson(c))
              .toList()
          : null,
    );
  }

  // Getters para compatibilidad con código existente
  String get name => nombre ?? '';
  String get agent => '${agenteNombres ?? ''} ${agenteApellidos ?? ''}'.trim();
  String get city => ciudadNombre ?? '';
  String get address => direccion ?? '';
  
  // Nuevos getters para la funcionalidad requerida
  String get tipoGarantiaVigente {
    if (contratos != null && contratos!.isNotEmpty) {
      final contratoActivo = contratos!.firstWhere(
        (c) => c.activo && c.estado == 'vigente',
        orElse: () => contratos!.first,
      );
      return contratoActivo.tipoGarantia ?? 'No especificado';
    }
    return 'No especificado';
  }
  
  double get montoGarantiaVigente {
    if (contratos != null && contratos!.isNotEmpty) {
      final contratoActivo = contratos!.firstWhere(
        (c) => c.activo && c.estado == 'vigente',
        orElse: () => contratos!.first,
      );
      return contratoActivo.montoGarantia ?? 0.0;
    }
    return 0.0;
  }
  
  DateTime? get fechaFinContrato => finContratoVigente;
  
  int get diasParaVencimiento {
    if (finContratoVigente == null) return 0;
    final ahora = DateTime.now();
    final diferencia = finContratoVigente!.difference(ahora).inDays;
    return diferencia > 0 ? diferencia : 0;
  }
  
  String get estadoContrato {
    if (finContratoVigente == null) return 'Sin fecha';
    final dias = diasParaVencimiento;
    if (dias == 0) return 'Vencido';
    if (dias <= 30) return 'Por vencer';
    return 'Vigente';
  }

  String get formattedMontoGarantia {
    if (montoGarantiaVigente == 0) return 'Bs. 0';
    final formatter = NumberFormat.currency(
      locale: 'es_BO',
      symbol: 'Bs. ',
      decimalDigits: 0,
    );
    return formatter.format(montoGarantiaVigente);
  }

  String get contratoFinFormatted {
    return fechaFinContrato != null
        ? DateFormat('dd/MM/yyyy').format(fechaFinContrato!)
        : 'Sin fecha';
  }

  String get contratoInicioFormatted {
    return inicioContratoVigente != null
        ? DateFormat('dd/MM/yyyy').format(inicioContratoVigente!)
        : 'Sin fecha';
  }

  String get vigenciaLicenciaFuncionamientoFormatted {
    return vigenciaLicenciaFuncionamiento != null
        ? DateFormat('dd/MM/yyyy').format(vigenciaLicenciaFuncionamiento!)
        : 'Sin fecha';
  }

  String get remainingTime {
    final dias = diasParaVencimiento;
    if (dias == 0) return 'Vencido';
    if (dias == 1) return '1 día';
    if (dias < 30) return '$dias días';
    if (dias < 365) {
      final meses = (dias / 30).round();
      return meses == 1 ? '1 mes' : '$meses meses';
    } else {
      final anios = (dias / 365).round();
      return anios == 1 ? '1 año' : '$anios años';
    }
  }

  String get remainingTimeLicenciaFuncionamiento {
    if (vigenciaLicenciaFuncionamiento == null) return 'Sin fecha';
    final ahora = DateTime.now();
    final diferencia = vigenciaLicenciaFuncionamiento!.difference(ahora).inDays;
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

  // Getters adicionales para compatibilidad
  String? get testimonioNotarial {
    if (contratos != null && contratos!.isNotEmpty) {
      final contratoActivo = contratos!.firstWhere(
        (c) => c.activo && c.estado == 'vigente',
        orElse: () => contratos!.first,
      );
      return contratoActivo.testimonioNotarial;
    }
    return null;
  }
  
  String? get tipoGarantia {
    if (contratos != null && contratos!.isNotEmpty) {
      final contratoActivo = contratos!.firstWhere(
        (c) => c.activo && c.estado == 'vigente',
        orElse: () => contratos!.first,
      );
      return contratoActivo.tipoGarantia;
    }
    return null;
  }
  
  // Getters para documentos (asumiendo que están en formato boolean)
  bool get ci => true; // Placeholder - ajustar según necesidad
  bool get croquis => true; // Placeholder - ajustar según necesidad
  bool get facturaServicioBasico => true; // Placeholder - ajustar según necesidad
  String? get nit => nitAgencia;
  bool get ruat => true; // Placeholder - ajustar según necesidad
  
  // Getter para compatibilidad con el gráfico de vencimientos
  DateTime? get contratoAgenciaFin => finContratoVigente;
}
