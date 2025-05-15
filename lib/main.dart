import 'package:dlza_legal_app/core/routes/app_router.dart';
import 'package:dlza_legal_app/core/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dlza_legal_app/core/providers/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kammuhwatpgwkaaoucbm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImthbW11aHdhdHBnd2thYW91Y2JtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE3OTU2OTksImV4cCI6MjA1NzM3MTY5OX0.Yz0mA2lbzqkFit0CsL79q3K0VHOGUPN9f9_6LNetosc',
  );

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'DLZA Legal App',
          debugShowCheckedModeBanner: false,
          theme:
              themeProvider.isDarkMode
                  ? AppTheme.darkTheme(context)
                  : AppTheme.lightTheme(context),
          routerConfig: appRouter(),
        );
      },
    );
  }
}
