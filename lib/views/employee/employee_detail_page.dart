import 'package:dlza_legal_app/core/components/custom_card.dart';
import 'package:dlza_legal_app/core/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeDetailPage extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailPage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Empleado'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con foto y nombre
            _buildHeader(theme),

            const SizedBox(height: 24),

            // Información personal
            _buildInfoSection(
              context: context,
              title: 'Información Personal',
              children: [
                _buildInfoRow(
                  context: context,
                  label: 'Documento',
                  value: employee.documento,
                  icon: Icons.badge,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Fecha de Nacimiento',
                  value: DateFormat('dd/MM/yyyy').format(employee.birthDate),
                  icon: Icons.cake,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Dirección',
                  value: employee.address,
                  icon: Icons.home,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Información laboral
            _buildInfoSection(
              context: context,
              title: 'Información Laboral',
              children: [
                _buildInfoRow(
                  context: context,
                  label: 'Cargo',
                  value: employee.position,
                  icon: Icons.work,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Departamento',
                  value: _formatDepartment(employee.department),
                  icon: Icons.corporate_fare,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Área',
                  value: employee.area,
                  icon: Icons.group_work,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Fecha de Ingreso',
                  value: DateFormat(
                    'dd/MM/yyyy',
                  ).format(employee.admissionDate),
                  icon: Icons.calendar_today,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Salario',
                  value: NumberFormat.currency(
                    symbol: 'Bs. ',
                    decimalDigits: 2,
                  ).format(employee.salary),
                  icon: Icons.attach_money,
                ),
                _buildInfoRow(
                  context: context,
                  label: 'Días de Vacaciones Disponibles',
                  value: employee.vacationDaysAvailable.toString(),
                  icon: Icons.beach_access,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Información de contacto
            _buildInfoSection(
              context: context,
              title: 'Información de Contacto',
              children: [
                _buildContactRow(
                  context: context,
                  label: 'Teléfono',
                  value: employee.phone,
                  icon: Icons.phone,
                  onTap: () => _makePhoneCall(employee.phone),
                ),
                _buildContactRow(
                  context: context,
                  label: 'WhatsApp',
                  value: employee.phone,
                  icon: Icons.chat,
                  onTap: () => _openWhatsApp(employee.phone),
                ),
                _buildContactRow(
                  context: context,
                  label: 'Email',
                  value: employee.email ?? '',
                  icon: Icons.email,
                  onTap: () => _sendEmail(employee.email ?? ''),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'employee-${employee.id}',
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(employee.image),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${employee.name} ${employee.lastName}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  employee.position,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.corporate_fare,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    employee.area,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection({
    required BuildContext context,
    required String title,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        theme.brightness == Brightness.light
                            ? Colors.black54
                            : Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        theme.brightness == Brightness.light
                            ? Colors.black54
                            : Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: onTap,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDepartment(String departmentName) {
    switch (departmentName) {
      case 'legal':
        return 'Legal';
      case 'administracion':
        return 'Administración';
      case 'contabilidad':
        return 'Contabilidad';
      case 'recursosHumanos':
        return 'Recursos Humanos';
      case 'marketing':
        return 'Marketing';
      case 'tecnologia':
        return 'Tecnología';
      case 'ventas':
        return 'Ventas';
      case 'produccion':
        return 'Producción';
      case 'logistica':
        return 'Logística';
      default:
        return departmentName;
    }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
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
