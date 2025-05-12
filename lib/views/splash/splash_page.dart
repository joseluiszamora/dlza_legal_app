import 'dart:async';
import 'package:dlza_legal_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
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
    // Navegar automáticamente después de 3 segundos
    _timer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        context.go(AppRoutes.navigation);
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
      body: Center(
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
                    size: 150,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Dlza Legal',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
