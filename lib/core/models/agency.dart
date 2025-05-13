class Agency {
  final int id;
  final String createdAt;
  final String nombre;
  final String agente;
  final String direccion;
  final String ciudad;
  final String latitud;
  final String longitud;
  final String ci;
  final String croquis;
  final String facturaServicioBasico;
  final String nit;
  final String licenciaDeFuncionamiento;
  final String vigenciaLicenciaFuncionamiento;
  final String nitAgencia;
  final String tipoGarantia;
  final String montoGarantia;
  final String testimonioNotarial;
  final String contratoAlquiler;
  final String contratoAgenciaInicio;
  final String contratoAgenciaFin;
  final String ruat;
  final String observaciones;
  final String contratoHasta;

  Agency({
    required this.id,
    required this.createdAt,
    required this.nombre,
    required this.agente,
    required this.direccion,
    required this.ciudad,
    required this.latitud,
    required this.longitud,
    required this.ci,
    required this.croquis,
    required this.facturaServicioBasico,
    required this.nit,
    required this.licenciaDeFuncionamiento,
    required this.vigenciaLicenciaFuncionamiento,
    required this.nitAgencia,
    required this.tipoGarantia,
    required this.montoGarantia,
    required this.testimonioNotarial,
    required this.contratoAlquiler,
    required this.contratoAgenciaInicio,
    required this.contratoAgenciaFin,
    required this.ruat,
    required this.observaciones,
    required this.contratoHasta,
  });

  factory Agency.fromJson(Map<String, dynamic> json) {
    return Agency(
      id: json['id'],
      createdAt: json['created_at'],
      nombre: json['nombre'],
      agente: json['agente'],
      direccion: json['direccion'],
      ciudad: json['ciudad'],
      latitud: json['latitud'],
      longitud: json['longitud'],
      ci: json['ci'],
      croquis: json['croquis'],
      facturaServicioBasico: json['facturaServicioBasico'],
      nit: json['nit'],
      licenciaDeFuncionamiento: json['licenciaDeFuncionamiento'],
      vigenciaLicenciaFuncionamiento: json['vigenciaLicenciaFuncionamiento'],
      nitAgencia: json['nitAgencia'],
      tipoGarantia: json['tipoGarantia'],
      montoGarantia: json['montoGarantia'],
      testimonioNotarial: json['testimonioNotarial'],
      contratoAlquiler: json['contratoAlquiler'],
      contratoAgenciaInicio: json['contratoAgenciaInicio'],
      contratoAgenciaFin: json['contratoAgenciaFin'],
      ruat: json['ruat'],
      observaciones: json['observaciones'],
      contratoHasta: json['contratoHasta'],
    );
  }
}
