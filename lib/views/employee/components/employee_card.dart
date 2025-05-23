import 'package:dlza_legal_app/core/components/contact_action_button.dart';
import 'package:dlza_legal_app/core/components/custom_card.dart';
import 'package:dlza_legal_app/core/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;

  const EmployeeCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Hero(
                  tag: 'employee-${employee.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      employee.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: theme.colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Información del empleado
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${employee.name} ${employee.lastName}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      employee.position,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          size: 14,
                          color:
                              theme.brightness == Brightness.light
                                  ? Colors.black54
                                  : Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            employee.area,
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.category,
                          size: 14,
                          color:
                              theme.brightness == Brightness.light
                                  ? Colors.black54
                                  : Colors.white70,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _getDepartmentLabel(employee.department),
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Divider(height: 24, color: Colors.black26),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ContactActionButton(
                icon: Icons.phone,
                label: 'Llamar',
                color: Colors.blue,
                onPressed: () => _makePhoneCall(employee.phone),
              ),
              ContactActionButton(
                icon: LineIcons.whatSApp,
                label: 'WhatsApp',
                color: Colors.green,
                onPressed: () => _openWhatsApp(employee.phone),
              ),
              ContactActionButton(
                icon: Icons.email,
                label: 'Email',
                color: Colors.red,
                onPressed: () => _sendEmail(employee.email ?? ''),
              ),
            ],
          ),
        ],
      ),
    );
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
    }
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
}
