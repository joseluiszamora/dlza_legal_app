import 'package:intl/intl.dart';

class Agency {
  final int id;
  final String name;
  final String agent;
  final String city;
  final String address;
  final String tipoGarantia;
  final double montoGarantia;
  final DateTime? contratoAgenciaInicio;
  final DateTime? contratoAgenciaFin;
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

  Agency({
    required this.id,
    required this.name,
    required this.agent,
    required this.city,
    required this.address,
    required this.tipoGarantia,
    required this.montoGarantia,
    this.contratoAgenciaInicio,
    this.contratoAgenciaFin,
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
  });

  factory Agency.fromJson(Map<String, dynamic> json) {
    return Agency(
      id: json['id'] as int,
      name: json['nombre'] as String,
      agent: json['agente'] as String? ?? 'Sin agente',
      city: json['ciudad'] as String? ?? 'Sin ciudad',
      address: json['direccion'] as String? ?? 'Sin dirección',
      tipoGarantia: json['tipoGarantia'] as String? ?? 'Sin garantía',
      montoGarantia: (json['montoGarantia'] as num?)?.toDouble() ?? 0.0,
      contratoAgenciaInicio:
          json['contratoAgenciaInicio'] != null
              ? DateTime.parse(json['contratoAgenciaInicio'] as String)
              : null,
      contratoAgenciaFin:
          json['contratoAgenciaFin'] != null
              ? DateTime.parse(json['contratoAgenciaFin'] as String)
              : null,
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
    );
  }

  String get formattedMontoGarantia {
    final formatter = NumberFormat.currency(symbol: 'Bs. ', decimalDigits: 2);
    return formatter.format(montoGarantia);
  }

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

// Lista de ciudades disponibles para filtrar
const List<String> availableCities = [
  'La Paz',
  'El Alto',
  'Cochabamba',
  'Santa Cruz',
  'Oruro',
  'Potosí',
  'Sucre',
  'Tarija',
];
