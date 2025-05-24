class Usuario {
  final int id;
  final String username;
  final String email;
  final String nombres;
  final String apellidos;
  final String documento;
  final String? imagenUrl;
  final DateTime createdAt;
  final String? area;
  final String? cargo;
  final String role;
  final bool activo;

  Usuario({
    required this.id,
    required this.username,
    required this.email,
    required this.nombres,
    required this.apellidos,
    required this.documento,
    this.imagenUrl,
    required this.createdAt,
    this.area,
    this.cargo,
    required this.role,
    required this.activo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      documento: json['documento'],
      imagenUrl: json['imagenUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      area: json['area'],
      cargo: json['cargo'],
      role: json['role'] ?? 'user',
      activo: json['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'nombres': nombres,
      'apellidos': apellidos,
      'documento': documento,
      'imagenUrl': imagenUrl,
      'createdAt': createdAt.toIso8601String(),
      'area': area,
      'cargo': cargo,
      'role': role,
      'activo': activo,
    };
  }

  // Datos básicos para localStorage
  Map<String, dynamic> toBasicJson() {
    return {
      'id': id,
      'nombres': nombres,
      'apellidos': apellidos,
      'imagenUrl': imagenUrl,
      'cargo': cargo,
      'area': area,
      'role': role,
    };
  }

  factory Usuario.fromBasicJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      username: '', // No se almacena en datos básicos
      email: '', // No se almacena en datos básicos
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      documento: '', // No se almacena en datos básicos
      imagenUrl: json['imagenUrl'],
      createdAt: DateTime.now(), // No se almacena en datos básicos
      area: json['area'],
      cargo: json['cargo'],
      role: json['role'],
      activo: true, // Asumimos que está activo si está en localStorage
    );
  }

  String get nombreCompleto => '$nombres $apellidos';

  bool get isAdmin => role == 'admin';
}
