import 'package:dlza_legal_app/core/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  const EmployeeCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(employee.image),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${employee.name} ${employee.lastName}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        employee.position,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Área: ${employee.area}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        'Departamento: ${_getDepartmentLabel(employee.department)}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.phone,
                  label: 'Llamar',
                  color: Colors.blue,
                  onPressed: () => _makePhoneCall(employee.phone),
                ),
                _buildActionButton(
                  icon: Icons.chat,
                  label: 'WhatsApp',
                  color: Colors.green,
                  onPressed: () => _openWhatsApp(employee.phone),
                ),
                _buildActionButton(
                  icon: Icons.email,
                  label: 'Email',
                  color: Colors.red,
                  onPressed: () => _sendEmail(employee.email),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return TextButton.icon(
      icon: Icon(icon, color: color),
      label: Text(label, style: TextStyle(color: color)),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    // Eliminar cualquier caracter no numérico
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final Uri uri = Uri.parse('https://wa.me/$cleanNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters({'subject': 'Contacto desde la app'}),
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  String _getDepartmentLabel(String departmentName) {
    final department = Department.values.firstWhere(
      (d) => d.name == departmentName,
      orElse: () => Department.legal,
    );

    switch (department) {
      case Department.legal:
        return 'Legal';
      case Department.administracion:
        return 'Administración';
      case Department.contabilidad:
        return 'Contabilidad';
      case Department.recursosHumanos:
        return 'RRHH';
      case Department.marketing:
        return 'Marketing';
      case Department.tecnologia:
        return 'Tecnología';
      case Department.ventas:
        return 'Ventas';
      case Department.produccion:
        return 'Producción';
      case Department.logistica:
        return 'Logística';
      default:
        return departmentName;
    }
  }
}
