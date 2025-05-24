class Ciudad {
  final int id;
  final String nombre;
  final String pais;
  final DateTime createdAt;

  Ciudad({
    required this.id,
    required this.nombre,
    required this.pais,
    required this.createdAt,
  });

  factory Ciudad.fromJson(Map<String, dynamic> json) {
    return Ciudad(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      pais: json['pais'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  String get nombreConPais => '$nombre, $pais';
}
