import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_theme.dart';
import '../../widgets/logout_button.dart';
import '../coordinador/crear_usuario_screen.dart';

class BrigadaScreen extends StatefulWidget {
  const BrigadaScreen({super.key});

  @override
  State<BrigadaScreen> createState() => _BrigadaScreenState();
}

class _BrigadaScreenState extends State<BrigadaScreen> {
  Map<String, dynamic>? usuario;

  int total = 0;
  int perros = 0;
  int gatos = 0;

  bool cargando = true;
  String sector = "Sin sector asignado";

  @override
  void initState() {
    super.initState();
    cargarDashboard();
  }

  Future<void> cargarDashboard() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw "No hay sesión iniciada.";
      }

      final data = await Supabase.instance.client
          .from("usuarios")
          .select()
          .eq("id", user.id)
          .maybeSingle();

      if (data == null) {
        throw "No se encontró el usuario en la tabla usuarios.";
      }

      final sectorId = data["sector_id"];

      final vacunaciones = await Supabase.instance.client
          .from("vacunaciones")
          .select()
          .eq("sector_id", sectorId);

      if (!mounted) return;

      setState(() {
        usuario = data;
        sector = sectorId?.toString() ?? "Sin sector asignado";
        total = vacunaciones.length;
        perros = vacunaciones.where((v) => v["tipo_mascota"] == "Perro").length;
        gatos = vacunaciones.where((v) => v["tipo_mascota"] == "Gato").length;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => cargando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar dashboard: $e")),
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
            fontWeight: FontWeight.w700,
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

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Brigada"),
          actions: const [LogoutButton()],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Brigada"),
        actions: const [LogoutButton()],
      ),
      body: RefreshIndicator(
        onRefresh: cargarDashboard,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: AppColors.beige,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.location_on_outlined,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Sector asignado",
                            style: TextStyle(color: AppColors.text),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            sector,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CrearUsuarioScreen(
                      rolFijo: "vacunador",
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text("Crear vacunador"),
            ),

            const SizedBox(height: 24),

            const Text(
              "Dashboard del sector",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),

            const SizedBox(height: 10),

            tarjeta(
              "Total vacunaciones",
              total,
              Icons.vaccines,
              AppColors.blue,
            ),

            tarjeta(
              "Perros vacunados",
              perros,
              Icons.pets,
              AppColors.navy,
            ),

            tarjeta(
              "Gatos vacunados",
              gatos,
              Icons.cruelty_free,
              const Color(0xFFC69A4A),
            ),
          ],
        ),
      ),
    );
  }
}