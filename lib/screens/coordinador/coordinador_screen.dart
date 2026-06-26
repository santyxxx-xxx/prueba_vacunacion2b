import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'sectores_screen.dart';
import '../../widgets/logout_button.dart';
import 'asignar_sector_screen.dart';
import '../../theme/app_theme.dart';
import 'crear_usuario_screen.dart';

class CoordinadorScreen extends StatefulWidget {
  const CoordinadorScreen({super.key});

  @override
  State<CoordinadorScreen> createState() => _CoordinadorScreenState();
}

class _CoordinadorScreenState extends State<CoordinadorScreen> {
  int total = 0;
  int perros = 0;
  int gatos = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final datos = await Supabase.instance.client.from("vacunaciones").select();

      if (!mounted) return;

      setState(() {
        total = datos.length;
        perros = datos.where((e) => e["tipo_mascota"] == "Perro").length;
        gatos = datos.where((e) => e["tipo_mascota"] == "Gato").length;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar datos: $e")),
      );
    }
  }

  Widget tarjeta(String titulo, int valor, IconData icono, Color color) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icono, color: color),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        trailing: Text(
          valor.toString(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.navy,
          ),
        ),
      ),
    );
  }

  Widget botonMenu({
    required String texto,
    required IconData icono,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icono),
      label: Text(texto),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coordinador"),
        actions: const [
          LogoutButton(),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: cargarDatos,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    "Resumen general",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),

                  const SizedBox(height: 12),

                  tarjeta(
                    "Total vacunaciones",
                    total,
                    Icons.vaccines,
                    AppColors.blue,
                  ),

                  tarjeta(
                    "Perros",
                    perros,
                    Icons.pets,
                    AppColors.navy,
                  ),

                  tarjeta(
                    "Gatos",
                    gatos,
                    Icons.cruelty_free,
                    const Color(0xFFC69A4A),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "Opciones",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navy,
                    ),
                  ),

                  const SizedBox(height: 12),

                  botonMenu(
                    texto: "Gestionar sectores",
                    icono: Icons.map_outlined,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SectoresScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  botonMenu(
                    texto: "Crear brigada",
                    icono: Icons.groups_outlined,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CrearUsuarioScreen(
                            rolFijo: "brigada",
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  botonMenu(
                    texto: "Asignar sectores",
                    icono: Icons.assignment_ind_outlined,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AsignarSectorScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}