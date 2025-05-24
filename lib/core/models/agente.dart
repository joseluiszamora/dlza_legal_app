class Agente {
  final int id;
  final String nombres;
  final String apellidos;
  final String? telefono;
  final String? email;
  final DateTime createdAt;

  Agente({
    required this.id,
    required this.nombres,
    required this.apellidos,
    this.telefono,
    this.email,
    required this.createdAt,
  });

  factory Agente.fromJson(Map<String, dynamic> json) {
    return Agente(
      id: json['id'] as int,
      nombres: json['nombres'] as String,
      apellidos: json['apellidos'] as String,
      telefono: json['telefono'] as String?,
      email: json['email'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  String get nombreCompleto => '$nombres $apellidos';
}
