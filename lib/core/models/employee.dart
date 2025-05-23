class Employee {
  final int id;
  final String nombres;
  final String apellidos;
  final String documento;
  final String tipoDocumento;
  final DateTime fechaNacimiento;
  final String? genero;
  final String? codigoSap;
  final DateTime fechaIngreso;
  final bool activo;
  final String? telefono;
  final String? email;
  final String? direccion;
  final String? imagenUrl;
  final int salario;
  final int vacacionesDisponibles;
  final String cargo;
  final int areaId;
  final int ciudadId;
  final DateTime createdAt;

  // Datos de relaciones
  final String? areaNombre;
  final String? areaDepartamento;
  final String? ciudadNombre;
  final String? ciudadPais;

  Employee({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.documento,
    required this.tipoDocumento,
    required this.fechaNacimiento,
    this.genero,
    this.codigoSap,
    required this.fechaIngreso,
    required this.activo,
    this.telefono,
    this.email,
    this.direccion,
    this.imagenUrl,
    required this.salario,
    required this.vacacionesDisponibles,
    required this.cargo,
    required this.areaId,
    required this.ciudadId,
    required this.createdAt,
    this.areaNombre,
    this.areaDepartamento,
    this.ciudadNombre,
    this.ciudadPais,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      documento: json['documento'],
      tipoDocumento: json['tipoDocumento'] ?? 'CI',
      fechaNacimiento: DateTime.parse(json['fechaNacimiento']),
      genero: json['genero'],
      codigoSap: json['codigoSap'],
      fechaIngreso: DateTime.parse(json['fechaIngreso']),
      activo: json['activo'] ?? true,
      telefono: json['telefono'],
      email: json['email'],
      direccion: json['direccion'],
      imagenUrl: json['imagenUrl'],
      salario: json['salario'] ?? 0,
      vacacionesDisponibles: json['vacacionesDisponibles'] ?? 0,
      cargo: json['cargo'],
      areaId: json['areaId'],
      ciudadId: json['ciudadId'],
      createdAt: DateTime.parse(json['createdAt']),
      // Datos de relaciones anidadas
      areaNombre: json['area']?['nombre'],
      areaDepartamento: json['area']?['departamento'],
      ciudadNombre: json['ciudad']?['nombre'],
      ciudadPais: json['ciudad']?['pais'],
    );
  }

  // Getters para compatibilidad con el código existente
  String get name => nombres;
  String get lastName => apellidos;
  String get position => cargo;
  String get area => areaNombre ?? '';
  String get department => areaDepartamento ?? '';
  String get phone => telefono ?? '';
  String get address => direccion ?? '';
  String get image =>
      imagenUrl ?? 'https://randomuser.me/api/portraits/men/1.jpg';
  DateTime get birthDate => fechaNacimiento;
  DateTime get admissionDate => fechaIngreso;
  double get salary => salario.toDouble();
  double get vacationDaysAvailable => vacacionesDisponibles.toDouble();
}

enum Department {
  legal,
  administracion,
  contabilidad,
  recursosHumanos,
  marketing,
  tecnologia,
  ventas,
  produccion,
  logistica,
}
