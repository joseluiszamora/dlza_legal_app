import 'package:dlza_legal_app/core/blocs/auth/auth_bloc.dart';
import 'package:dlza_legal_app/core/constants/app_colors.dart';
import 'package:dlza_legal_app/core/constants/app_defaults.dart';
import 'package:dlza_legal_app/core/layouts/layout_main.dart';
import 'package:dlza_legal_app/core/providers/theme_provider.dart';
import 'package:dlza_legal_app/views/agency/agency_page.dart';
import 'package:dlza_legal_app/views/home/home_page.dart';
import 'package:dlza_legal_app/views/marca/marca_page.dart';
import 'package:dlza_legal_app/views/navigation/components/header_section.dart';
import 'package:dlza_legal_app/views/employee/employee_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class NavigationBarPage extends StatefulWidget {
  const NavigationBarPage({super.key});

  @override
  State<NavigationBarPage> createState() => _NavigationBarPageState();
}

class _NavigationBarPageState extends State<NavigationBarPage> {
  int _pageSelected = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    //* Pages List
    List<Widget> pages = [
      const HomePage(),
      const EmployeePage(),
      const AgencyPage(),
      const MarcaPage(),
    ];

    List<String> titles = [
      'Directorio de Personal',
      'Inicio',
      'Agencias',
      'Marcas',
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: HeaderSection(
        title: titles[_pageSelected],
        openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      drawer: _buildDrawer(context),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: LayoutMain(content: pages[_pageSelected]),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color:
              theme.brightness == Brightness.light
                  ? AppColors.navigationBarLight
                  : AppColors.navigationBarDark,
          // color: Colors.red,
          borderRadius: BorderRadius.circular(AppDefaults.margin),
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withAlpha(1)),
          ],
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8),
            child: GNav(
              curve: Curves.easeIn,
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.red[100]!,
              gap: 8,
              activeColor: AppColors.primary,
              iconSize: 30,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color:
                  theme.brightness == Brightness.light
                      ? AppColors.primary
                      : Colors.white,
              tabs: [
                GButton(icon: LineIcons.home, text: 'Inicio'),
                GButton(icon: LineIcons.userCircle, text: 'Personas'),
                GButton(icon: LineIcons.fileContract, text: 'Agencias'),
                GButton(icon: LineIcons.certificate, text: 'Marcas'),
              ],
              selectedIndex: _pageSelected,
              onTabChange: (index) {
                setState(() {
                  _pageSelected = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(
            icon: Icons.person,
            text: 'Perfil',
            onTap: () => _navigateTo(context, '/profile'),
          ),
          _buildDrawerItem(
            icon: Icons.history,
            text: 'Historial',
            onTap: () => _navigateTo(context, '/history'),
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Configuración',
            onTap: () => _navigateTo(context, '/settings'),
          ),
          // Selector de tema
          ListTile(
            leading: Icon(
              themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            ),
            title: Text(
              'Tema ${themeProvider.isDarkMode ? 'Oscuro' : 'Claro'}',
            ),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (_) {
                themeProvider.toggleTheme();
              },
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.help,
            text: 'Ayuda',
            onTap: () => _navigateTo(context, '/help'),
          ),
          _buildDrawerItem(
            icon: Icons.exit_to_app,
            text: 'Cerrar sesión',
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user;
          return DrawerHeader(
            decoration: BoxDecoration(color: const Color(0xFF0bbfdf)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      user.imagenUrl?.isNotEmpty == true
                          ? NetworkImage(user.imagenUrl!)
                          : null,
                  child:
                      user.imagenUrl?.isEmpty != false
                          ? Text(
                            '${user.nombres.isNotEmpty ? user.nombres[0] : ''}${user.apellidos.isNotEmpty ? user.apellidos[0] : ''}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                          : null,
                ),
                SizedBox(height: 10),
                Text(
                  '${user.nombres} ${user.apellidos}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${user.cargo ?? 'Sin cargo'} - ${user.area ?? 'Sin área'}',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }

        // Estado de carga o no autenticado
        return DrawerHeader(
          decoration: BoxDecoration(color: const Color(0xFF0bbfdf)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 30,
                child: Icon(Icons.person, size: 30, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Cargando...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(leading: Icon(icon), title: Text(text), onTap: onTap);
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context); // Cierra el drawer
    Navigator.pushNamed(context, route);
  }

  void _logout(BuildContext context) {
    // Navigator.pop(context);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cerrar Sesión'),
            content: const Text('¿Está seguro que desea cerrar sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AuthBloc>().add(AuthLogout());
                },
                child: const Text('Cerrar Sesión'),
              ),
            ],
          ),
    ); // Cierra el drawer
  }
} // Lógica para cerrar sesión
