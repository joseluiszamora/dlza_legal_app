import 'package:dlza_legal_app/core/routes/app_router.dart';
import 'package:dlza_legal_app/core/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kammuhwatpgwkaaoucbm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImthbW11aHdhdHBnd2thYW91Y2JtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE3OTU2OTksImV4cCI6MjA1NzM3MTY5OX0.Yz0mA2lbzqkFit0CsL79q3K0VHOGUPN9f9_6LNetosc',
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DLZA legal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      routerConfig: appRouter(),
    );
  }
}
