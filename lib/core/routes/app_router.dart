import 'package:dlza_legal_app/core/routes/app_routes.dart';
import 'package:dlza_legal_app/views/auth/login_page.dart';
import 'package:dlza_legal_app/views/navigation/navigation_bar_page.dart';
import 'package:dlza_legal_app/views/splash/splash_page.dart';
import 'package:go_router/go_router.dart';

GoRouter appRouter() => GoRouter(
  // Cambiar initialLocation al splash
  initialLocation: AppRoutes.splash,
  routes: publicRoutes(),
);

List<RouteBase> publicRoutes() => [
  /* <---- AUTH -----> */
  GoRoute(
    path: AppRoutes.splash,
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
    path: AppRoutes.navigation,
    builder: (context, state) => const NavigationBarPage(),
  ),
  GoRoute(
    path: AppRoutes.authLogin,
    builder: (context, state) => const LoginPage(),
  ),
];
