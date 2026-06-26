import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_theme.dart';
import '../../widgets/logout_button.dart';

class BrigadaScreen extends StatefulWidget {
  const BrigadaScreen({super.key});

  @override
  State<BrigadaScreen> createState() => _BrigadaScreenState();
}

class _BrigadaScreenState extends State<BrigadaScreen> {
  Map<String, dynamic>? usuario;
  List vacunadores = [];

  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  Future<void> cargarUsuario() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw "No hay usuario con sesión iniciada.";
      }

      final data = await Supabase.instance.client
          .from("usuarios")
          .select()
          .eq("id", user.id)
          .maybeSingle();

      if (data == null) {
        throw "No se encontró el usuario en la tabla usuarios.";
      }

      final listaVacunadores = await Supabase.instance.client
          .from("usuarios")
          .select()
          .eq("rol", "vacunador")
          .eq("sector_id", data["sector_id"]);

      if (!mounted) return;

      setState(() {
        usuario = data;
        vacunadores = listaVacunadores;
        cargando = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Brigada"),
          actions: const [
            LogoutButton(),
          ],
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Brigada"),
          actions: const [
            LogoutButton(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 54,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "No se pudo cargar Brigada",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.text),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          cargando = true;
                          error = null;
                        });
                        cargarUsuario();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Intentar de nuevo"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Brigada"),
        actions: const [
          LogoutButton(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: cargarUsuario,
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
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${usuario?["sector_id"] ?? "Ninguno"}",
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

            const SizedBox(height: 22),

            const Text(
              "Vacunadores",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),

            const SizedBox(height: 10),

            if (vacunadores.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(
                  child: Text(
                    "No hay vacunadores asignados a este sector.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.text),
                  ),
                ),
              )
            else
              ...vacunadores.map((v) {
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.sky,
                      child: Icon(
                        Icons.person_outline,
                        color: AppColors.navy,
                      ),
                    ),
                    title: Text(
                      "${v["nombres"] ?? "Sin nombre"} ${v["apellidos"] ?? ""}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.navy,
                      ),
                    ),
                    subtitle: Text(v["correo"] ?? ""),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}