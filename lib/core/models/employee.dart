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

// Modelo para Area
class Area {
  final int id;
  final String nombre;
  final String? departamento;
  final DateTime createdAt;

  Area({
    required this.id,
    required this.nombre,
    this.departamento,
    required this.createdAt,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      nombre: json['nombre'],
      departamento: json['departamento'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  String get name => nombre;
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

// Lista de empleados fake - comentada para mantener como referencia
/*
final List<Employee> employees = [
  Employee(
    id: 1,
    name: 'Juan',
    lastName: 'Pérez',
    area: 'Administración',
    department: Department.administracion.name,
    position: 'Gerente',
    email: 'demo.qmail.bo',
    phone: '123456789',
    address: 'Calle Falsa 123',
    image: 'https://randomuser.me/api/portraits/men/1.jpg',
    document: '1234567',
    birthDate: DateTime(1980, 6, 15),
    admissionDate: DateTime(2015, 3, 1),
    salary: 15000.0,
    vacationDaysAvailable: 15.0,
  ),
  Employee(
    id: 2,
    name: 'Ana',
    lastName: 'Gómez',
    area: 'Recursos Humanos',
    department: Department.recursosHumanos.name,
    position: 'Analista',
    email: 'demo.qmail.bo',
    phone: '987654321',
    address: 'Avenida Siempre Viva 456',
    image: 'https://randomuser.me/api/portraits/women/2.jpg',
    document: '2345678',
    birthDate: DateTime(1985, 7, 22),
    admissionDate: DateTime(2017, 6, 15),
    salary: 9000.0,
    vacationDaysAvailable: 10.0,
  ),
  Employee(
    id: 3,
    name: 'Luis',
    lastName: 'Martínez',
    area: 'Contabilidad',
    department: Department.contabilidad.name,
    position: 'Contador',
    email: 'demo.qmail.bo',
    phone: '456789123',
    address: 'Calle Falsa 789',
    image: 'https://randomuser.me/api/portraits/men/3.jpg',
    document: '3456789',
    birthDate: DateTime(1982, 6, 10),
    admissionDate: DateTime(2016, 4, 1),
    salary: 10000.0,
    vacationDaysAvailable: 12.0,
  ),
  Employee(
    id: 4,
    name: 'María',
    lastName: 'López',
    area: 'Marketing',
    department: Department.marketing.name,
    position: 'Especialista',
    email: 'demo.qmail.bo',
    phone: '321654987',
    address: 'Avenida Siempre Viva 123',
    image: 'https://randomuser.me/api/portraits/women/4.jpg',
    document: '4567890',
    birthDate: DateTime(1988, 9, 5),
    admissionDate: DateTime(2018, 6, 15),
    salary: 8500.0,
    vacationDaysAvailable: 8.0,
  ),
  Employee(
    id: 5,
    name: 'Carlos',
    lastName: 'Hernández',
    area: 'Tecnología',
    department: Department.tecnologia.name,
    position: 'Desarrollador',
    email: 'demo.qmail.bo',
    phone: '654321789',
    address: 'Calle Falsa 456',
    image: 'https://randomuser.me/api/portraits/men/5.jpg',
    document: '5678901',
    birthDate: DateTime(1990, 11, 15),
    admissionDate: DateTime(2019, 8, 1),
    salary: 12000.0,
    vacationDaysAvailable: 10.0,
  ),
  Employee(
    id: 6,
    name: 'Laura',
    lastName: 'García',
    area: 'Ventas',
    department: Department.ventas.name,
    position: 'Ejecutiva',
    email: 'demo.qmail.bo',
    phone: '789123456',
    address: 'Avenida Siempre Viva 789',
    image: 'https://randomuser.me/api/portraits/women/6.jpg',
    document: '6789012',
    birthDate: DateTime(1987, 6, 28),
    admissionDate: DateTime(2017, 9, 1),
    salary: 9500.0,
    vacationDaysAvailable: 12.0,
  ),
  Employee(
    id: 7,
    name: 'Pedro',
    lastName: 'Ramírez',
    area: 'Producción',
    department: Department.produccion.name,
    position: 'Operario',
    email: 'demo.qmail.bo',
    phone: '159753486',
    address: 'Calle Falsa 321',
    image: 'https://randomuser.me/api/portraits/men/7.jpg',
    document: '7890123',
    birthDate: DateTime(1983, 5, 15),
    admissionDate: DateTime(2015, 5, 25),
    salary: 7500.0,
    vacationDaysAvailable: 15.0,
  ),
  Employee(
    id: 8,
    name: 'Sofía',
    lastName: 'Torres',
    area: 'Logística',
    department: Department.logistica.name,
    position: 'Coordinadora',
    email: 'demo.qmail.bo',
    phone: '753159486',
    address: 'Avenida Siempre Viva 321',
    image: 'https://randomuser.me/api/portraits/women/8.jpg',
    document: '8901234',
    birthDate: DateTime(1986, 5, 16),
    admissionDate: DateTime(2018, 5, 30),
    salary: 8800.0,
    vacationDaysAvailable: 10.0,
  ),
  Employee(
    id: 9,
    name: 'Diego',
    lastName: 'Fernández',
    area: 'Legal',
    department: Department.legal.name,
    position: 'Abogado',
    email: 'demo.qmail.bo',
    phone: '951753486',
    address: 'Calle Falsa 654',
    image: 'https://randomuser.me/api/portraits/men/9.jpg',
    document: '9012345',
    birthDate: DateTime(1979, 5, 14),
    admissionDate: DateTime(2014, 7, 1),
    salary: 7000.0,
    vacationDaysAvailable: 20.0,
  ),
  Employee(
    id: 10,
    name: 'Valentina',
    lastName: 'Cruz',
    area: 'Recursos Humanos',
    department: Department.recursosHumanos.name,
    position: 'Asistente',
    email: 'demo.qmail.bo',
    phone: '852963741',
    address: 'Avenida Siempre Viva 654',
    image: 'https://randomuser.me/api/portraits/women/10.jpg',
    document: '0123456',
    birthDate: DateTime(1992, 5, 15),
    admissionDate: DateTime(2020, 1, 15),
    salary: 2500.0,
    vacationDaysAvailable: 5.0,
  ),
];
*/
