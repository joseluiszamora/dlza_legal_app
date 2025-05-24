import 'package:dlza_legal_app/core/blocs/auth/auth_bloc.dart';
import 'package:dlza_legal_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial) {
          // Verificar el estado de autenticación al iniciar
          context.read<AuthBloc>().add(AuthCheckStatus());
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is AuthAuthenticated) {
          return child;
        }

        // Si no está autenticado, redirigir al login
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go(AppRoutes.authLogin);
        });

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
