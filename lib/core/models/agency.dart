import 'package:intl/intl.dart';
import 'contrato_agencia.dart';

class Agency {
  final int id;
  final String nombre;
  final String direccion;
  final int agenteId;
  final int ciudadId;
  final String tipoGarantia;
  final double montoGarantia;
  final bool ci;
  final bool croquis;
  final bool facturaServicioBasico;
  final bool nit;
  final bool licenciaDeFuncionamiento;
  final bool ruat;
  final double? latitud;
  final double? longitud;
  final String testimonioNotarial;
  final DateTime? vigenciaLicenciaFuncionamiento;
  final String observaciones;
  final DateTime createdAt;

  // Datos de relaciones anidadas
  final String? agenteNombres;
  final String? agenteApellidos;
  final String? agenteTelefono;
  final String? agenteEmail;
  final String? ciudadNombre;
  final String? ciudadPais;
  final List<ContratoAgencia>? contratos;

  Agency({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.agenteId,
    required this.ciudadId,
    required this.tipoGarantia,
    required this.montoGarantia,
    required this.ci,
    required this.croquis,
    required this.facturaServicioBasico,
    required this.nit,
    required this.licenciaDeFuncionamiento,
    required this.ruat,
    this.latitud,
    this.longitud,
    required this.testimonioNotarial,
    this.vigenciaLicenciaFuncionamiento,
    required this.observaciones,
    required this.createdAt,
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
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      direccion: json['direccion'] as String? ?? 'Sin dirección',
      agenteId: json['agenteId'] as int,
      ciudadId: json['ciudadId'] as int,
      tipoGarantia: json['tipoGarantia'] as String? ?? 'Sin garantía',
      montoGarantia: (json['montoGarantia'] as num?)?.toDouble() ?? 0.0,
      ci: json['ci'] as bool? ?? false,
      croquis: json['croquis'] as bool? ?? false,
      facturaServicioBasico: json['facturaServicioBasico'] as bool? ?? false,
      nit: json['nit'] as bool? ?? false,
      licenciaDeFuncionamiento:
          json['licenciaDeFuncionamiento'] as bool? ?? false,
      ruat: json['ruat'] as bool? ?? false,
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      testimonioNotarial:
          json['testimonioNotarial'] as String? ?? 'No registrado',
      vigenciaLicenciaFuncionamiento:
          json['vigenciaLicenciaFuncionamiento'] != null
              ? DateTime.parse(json['vigenciaLicenciaFuncionamiento'] as String)
              : null,
      observaciones: json['observaciones'] as String? ?? 'Sin observaciones',
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
      // Datos de relaciones anidadas
      agenteNombres: json['agente']?['nombres'],
      agenteApellidos: json['agente']?['apellidos'],
      agenteTelefono: json['agente']?['telefono'],
      agenteEmail: json['agente']?['email'],
      ciudadNombre: json['ciudad']?['nombre'],
      ciudadPais: json['ciudad']?['pais'],
      contratos:
          (json['contratos'] as List<dynamic>?)
              ?.map((e) => ContratoAgencia.fromJson(e))
              .toList(),
    );
  }

  // Getters para compatibilidad con el código existente
  String get name => nombre;
  String get agent =>
      agenteNombres != null && agenteApellidos != null
          ? '$agenteNombres $agenteApellidos'
          : 'Sin agente';
  String get city => ciudadNombre ?? 'Sin ciudad';
  String get address => direccion;

  String get formattedMontoGarantia {
    final formatter = NumberFormat.currency(symbol: 'Bs. ', decimalDigits: 2);
    return formatter.format(montoGarantia);
  }

  // Obtener el contrato más reciente activo
  ContratoAgencia? get contratoActivo {
    if (contratos == null || contratos!.isEmpty) return null;

    try {
      return contratos!
          .where((c) => c.estaActivo)
          .reduce((a, b) => a.fechaInicio.isAfter(b.fechaInicio) ? a : b);
    } catch (e) {
      return null;
    }
  }

  DateTime? get contratoAgenciaInicio => contratoActivo?.fechaInicio;
  DateTime? get contratoAgenciaFin => contratoActivo?.fechaFin;

  String get contratoFinFormatted {
    return contratoAgenciaFin != null
        ? DateFormat('dd/MM/yyyy').format(contratoAgenciaFin!)
        : 'Sin fecha';
  }

  String get contratoInicioFormatted {
    return contratoAgenciaInicio != null
        ? DateFormat('dd/MM/yyyy').format(contratoAgenciaInicio!)
        : 'Sin fecha';
  }

  String get vigenciaLicenciaFuncionamientoFormatted {
    return vigenciaLicenciaFuncionamiento != null
        ? DateFormat('dd/MM/yyyy').format(vigenciaLicenciaFuncionamiento!)
        : 'Sin fecha';
  }

  String get remainingTime {
    if (contratoAgenciaFin == null) return 'Sin fecha de finalización';

    final now = DateTime.now();
    final difference = contratoAgenciaFin!.difference(now);

    if (difference.isNegative) {
      return 'Contrato vencido';
    }

    if (difference.inDays > 30) {
      int months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'mes' : 'meses'} restantes';
    } else {
      return '${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'} restantes';
    }
  }

  String get remainingTimeLicenciaFuncionamiento {
    if (vigenciaLicenciaFuncionamiento == null) {
      return 'Sin fecha';
    }

    final now = DateTime.now();
    final difference = vigenciaLicenciaFuncionamiento!.difference(now);

    if (difference.isNegative) {
      return 'Licencia vencida';
    }

    if (difference.inDays > 30) {
      int months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'mes' : 'meses'} restantes';
    } else {
      return '${difference.inDays} ${difference.inDays == 1 ? 'día' : 'días'} restantes';
    }
  }
}
