import 'package:dlza_legal_app/core/blocs/auth/auth_bloc.dart';
import 'package:dlza_legal_app/core/blocs/blocs.dart';
import 'package:dlza_legal_app/core/blocs/service_locator.dart';
import 'package:dlza_legal_app/core/repositories/auth_repository.dart';
import 'package:dlza_legal_app/core/routes/app_router.dart';
import 'package:dlza_legal_app/core/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dlza_legal_app/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  serviceLocatorInit();
  await Supabase.initialize(
    url: 'https://kammuhwatpgwkaaoucbm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImthbW11aHdhdHBnd2thYW91Y2JtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE3OTU2OTksImV4cCI6MjA1NzM3MTY5OX0.Yz0mA2lbzqkFit0CsL79q3K0VHOGUPN9f9_6LNetosc',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // Repositorio de autenticación
        Provider<AuthRepository>(create: (_) => AuthRepository()),
      ],
      child: const BlocsProviders(),
    ),
  );
}

class BlocsProviders extends StatelessWidget {
  const BlocsProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AgencyBloc>(), lazy: true),
        BlocProvider(create: (context) => getIt<MarcaBloc>(), lazy: true),
        BlocProvider(create: (context) => getIt<EmployeeBloc>(), lazy: true),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create:
                  (context) =>
                      AuthBloc(authRepository: context.read<AuthRepository>())
                        ..add(AuthCheckStatus()),
            ),
          ],
          child: MaterialApp.router(
            title: 'DLZA Legal App',
            debugShowCheckedModeBanner: false,
            theme:
                themeProvider.isDarkMode
                    ? AppTheme.darkTheme(context)
                    : AppTheme.lightTheme(context),
            routerConfig: appRouter(),
          ),
        );
      },
    );
  }
}
