import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_theme.dart';

class SectoresScreen extends StatefulWidget {
  const SectoresScreen({super.key});

  @override
  State<SectoresScreen> createState() => _SectoresScreenState();
}

class _SectoresScreenState extends State<SectoresScreen> {
  final nombreController = TextEditingController();
  List sectores = [];
  bool loading = false;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarSectores();
  }

  Future<void> cargarSectores() async {
    try {
      final data = await Supabase.instance.client
          .from('sectores')
          .select()
          .order('nombre', ascending: true);

      if (!mounted) return;

      setState(() {
        sectores = data;
        cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => cargando = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar sectores: $e")),
      );
    }
  }

  Future<void> crearSector() async {
    if (nombreController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Escribe el nombre del sector")),
      );
      return;
    }

    try {
      setState(() => loading = true);

      await Supabase.instance.client.from('sectores').insert({
        'nombre': nombreController.text.trim(),
      });

      nombreController.clear();
      await cargarSectores();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sector creado correctamente")),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al crear sector: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void dispose() {
    nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sectores"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: "Nombre del sector",
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                IconButton.filled(
                  onPressed: loading ? null : crearSector,
                  icon: loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: cargando
                  ? const Center(child: CircularProgressIndicator())
                  : sectores.isEmpty
                      ? const Center(
                          child: Text(
                            "No hay sectores registrados todavía.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.text),
                          ),
                        )
                      : ListView.builder(
                          itemCount: sectores.length,
                          itemBuilder: (context, index) {
                            final s = sectores[index];

                            return Card(
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: AppColors.beige,
                                  child: Icon(
                                    Icons.map_outlined,
                                    color: AppColors.navy,
                                  ),
                                ),
                                title: Text(
                                  s['nombre'] ?? 'Sin nombre',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.navy,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}