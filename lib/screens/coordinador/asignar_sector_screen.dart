import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AsignarSectorScreen extends StatefulWidget {
  const AsignarSectorScreen({super.key});

  @override
  State<AsignarSectorScreen> createState() => _AsignarSectorScreenState();
}

class _AsignarSectorScreenState extends State<AsignarSectorScreen> {
  List usuarios = [];
  List sectores = [];
  Map<String, dynamic> seleccion = {};

  @override
  void initState() {
    super.initState();
    cargarUsuarios();
    cargarSectores();
  }

  Future<void> cargarUsuarios() async {
    usuarios = await Supabase.instance.client
        .from("usuarios")
        .select();

    setState(() {});
  }

  Future<void> cargarSectores() async {
    sectores = await Supabase.instance.client
        .from("sectores")
        .select();

    setState(() {});
  }

  Future<void> guardarSector(
      String usuarioId, dynamic sectorId) async {
    await Supabase.instance.client
        .from("usuarios")
        .update({
          "sector_id": sectorId,
        })
        .eq("id", usuarioId);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Sector asignado correctamente"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Asignar sectores"),
      ),
      body: usuarios.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${usuario["nombres"]} ${usuario["apellidos"]}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(usuario["correo"]),

                        const SizedBox(height: 15),

                        DropdownButtonFormField(
                          value: seleccion[usuario["id"]],
                          decoration: const InputDecoration(
                            labelText: "Sector",
                          ),
                          items: sectores.map((sector) {
                            return DropdownMenuItem(
                              value: sector["id"],
                              child: Text(sector["nombre"]),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              seleccion[usuario["id"]] =
                                  value;
                            });
                          },
                        ),

                        const SizedBox(height: 15),

                        ElevatedButton(
                          onPressed: () {
                            guardarSector(
                              usuario["id"],
                              seleccion[usuario["id"]],
                            );
                          },
                          child: const Text("Guardar"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}