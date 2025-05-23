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
