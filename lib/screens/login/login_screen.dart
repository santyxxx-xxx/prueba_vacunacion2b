import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../coordinador/coordinador_screen.dart';
import '../brigada/brigada_screen.dart';
import '../vacunador/vacunador_screen.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;

  Future<void> login() async {
    try {
      setState(() => loading = true);

      await Supabase.instance.client.auth.signInWithPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw "No se pudo obtener el usuario actual.";
      }

      final datos = await Supabase.instance.client
          .from('usuarios')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (datos == null) {
        throw "El usuario no existe en la tabla usuarios.";
      }

      final rol = datos["rol"].toString().trim().toLowerCase();

      if (!mounted) return;

      Widget screen;

      if (rol == "coordinador") {
        screen = const CoordinadorScreen();
      } else if (rol == "brigada") {
        screen = const BrigadaScreen();
      } else if (rol == "vacunador") {
        screen = const VacunadorScreen();
      } else {
        throw "Rol no reconocido: $rol";
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => screen),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.health_and_safety,
                  size: 82,
                  color: AppColors.navy,
                ),

                const SizedBox(height: 16),

                const Text(
                  "Vacunación Animal",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navy,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Ingresa con tu correo y contraseña",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.text,
                  ),
                ),

                const SizedBox(height: 34),

                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Correo",
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  onSubmitted: (_) {
                    if (!loading) login();
                  },
                ),

                const SizedBox(height: 26),

                ElevatedButton.icon(
                  onPressed: loading ? null : login,
                  icon: loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.login),
                  label: Text(loading ? "Ingresando..." : "Ingresar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}