import 'dart:async';
import 'package:dlza_legal_app/core/blocs/auth/auth_bloc.dart';
import 'package:dlza_legal_app/core/constants/app_colors.dart';
import 'package:dlza_legal_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  void _initializeApp() {
    // Verificar el estado de autenticación
    context.read<AuthBloc>().add(AuthCheckStatus());

    // Navegar automáticamente después de verificar la autenticación
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        final authState = context.read<AuthBloc>().state;
        if (authState is AuthAuthenticated) {
          context.go(AppRoutes.navigation);
        } else {
          context.go(AppRoutes.authLogin);
        }
      }
    });
  }

  @override
  void dispose() {
    // Cancelar el timer cuando el widget se desmonte
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          // Si el estado cambia durante el splash, navegamos inmediatamente
          if (state is AuthAuthenticated || state is AuthUnauthenticated) {
            _timer?.cancel();
            if (mounted) {
              if (state is AuthAuthenticated) {
                context.go(AppRoutes.navigation);
              } else {
                context.go(AppRoutes.authLogin);
              }
            }
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo o imagen de la app
              Image.asset(
                'assets/images/logo.png',
                height: 150,
                // Si la imagen no existe, usa un fallback
                errorBuilder:
                    (context, error, stackTrace) => const Icon(
                      Icons.icecream,
                      size: 120,
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 30),
              Text(
                'DLZA Legal',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
