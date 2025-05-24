import 'package:dlza_legal_app/core/blocs/auth/auth_bloc.dart';
import 'package:dlza_legal_app/core/components/auth_guard.dart';
import 'package:dlza_legal_app/core/routes/app_routes.dart';
import 'package:dlza_legal_app/views/auth/login_page.dart';
import 'package:dlza_legal_app/views/navigation/navigation_bar_page.dart';
import 'package:dlza_legal_app/views/splash/splash_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter appRouter() => GoRouter(
  // Cambiar initialLocation al splash
  initialLocation: AppRoutes.splash,
  routes: publicRoutes(),
  redirect: (context, state) {
    final authState = context.read<AuthBloc>().state;
    final isLoginRoute = state.matchedLocation == AppRoutes.authLogin;
    final isSplashRoute = state.matchedLocation == AppRoutes.splash;

    // Si está en splash, permitir
    if (isSplashRoute) return null;

    // Si no está autenticado y no está en login, redirigir a login
    if (authState is! AuthAuthenticated && !isLoginRoute) {
      return AppRoutes.authLogin;
    }

    // Si está autenticado y está en login, redirigir a home
    if (authState is AuthAuthenticated && isLoginRoute) {
      return AppRoutes.navigation;
    }

    return null;
  },
);

List<RouteBase> publicRoutes() => [
  /* <---- AUTH -----> */
  GoRoute(
    path: AppRoutes.splash,
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
    path: AppRoutes.authLogin,
    name: 'Login',
    builder: (context, state) => const LoginPage(),
  ),
  GoRoute(
    path: AppRoutes.navigation,
    name: 'Inicio',
    builder: (context, state) => const AuthGuard(child: NavigationBarPage()),
  ),
];
