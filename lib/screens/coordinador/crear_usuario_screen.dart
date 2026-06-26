import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CrearUsuarioScreen extends StatefulWidget {
  const CrearUsuarioScreen({super.key});

  @override
  State<CrearUsuarioScreen> createState() => _CrearUsuarioScreenState();
}

class _CrearUsuarioScreenState extends State<CrearUsuarioScreen> {
  final cedula = TextEditingController();
  final nombres = TextEditingController();
  final apellidos = TextEditingController();
  final telefono = TextEditingController();
  final correo = TextEditingController();

  String rol = "brigada";
  bool loading = false;

  Future<void> crearUsuario() async {
    setState(() => loading = true);

    final auth = await Supabase.instance.client.auth.signUp(
      email: correo.text.trim(),
      password: "Ecuador2026",
    );

    final userId = auth.user!.id;

    await Supabase.instance.client.from('usuarios').insert({
      "id": userId,
      "cedula": cedula.text,
      "nombres": nombres.text,
      "apellidos": apellidos.text,
      "telefono": telefono.text,
      "correo": correo.text,
      "rol": rol,
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Usuario creado")),
    );

    cedula.clear();
    nombres.clear();
    apellidos.clear();
    telefono.clear();
    correo.clear();

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Usuario")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: cedula, decoration: const InputDecoration(labelText: "Cédula")),
            TextField(controller: nombres, decoration: const InputDecoration(labelText: "Nombres")),
            TextField(controller: apellidos, decoration: const InputDecoration(labelText: "Apellidos")),
            TextField(controller: telefono, decoration: const InputDecoration(labelText: "Teléfono")),
            TextField(controller: correo, decoration: const InputDecoration(labelText: "Correo")),
            
            const SizedBox(height: 10),

            DropdownButton<String>(
              value: rol,
              items: const [
                DropdownMenuItem(value: "brigada", child: Text("Brigada")),
                DropdownMenuItem(value: "vacunador", child: Text("Vacunador")),
              ],
              onChanged: (value) {
                setState(() {
                  rol = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: loading ? null : crearUsuario,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Crear usuario"),
            )
          ],
        ),
      ),
    );
  }
}