import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:prueba2bim/screens/login/login_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zjlpsjsrbpfqdeubimis.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpqbHBzanNyYnBmcWRldWJpbWlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI0NTAxNjksImV4cCI6MjA5ODAyNjE2OX0._h0HQpG9OL5NzucZKzaZrhDNtYW0eukbhxrVkSM3Pg0',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi App',
      theme: AppTheme.light(),
      home: const LoginScreen(),
    );
  }
}