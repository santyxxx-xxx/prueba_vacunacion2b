import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/logout_button.dart';

class ListaVacunacionesScreen extends StatefulWidget {
  const ListaVacunacionesScreen({super.key});

  @override
  State<ListaVacunacionesScreen> createState() =>
      _ListaVacunacionesScreenState();
}

class _ListaVacunacionesScreenState
    extends State<ListaVacunacionesScreen> {

  List vacunaciones = [];

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    final datos = await Supabase.instance.client
        .from("vacunaciones")
        .select()
        .order("fecha", ascending: false);

    setState(() {
      vacunaciones = datos;
    });
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
      body: ListView.builder(
        itemCount: vacunaciones.length,
        itemBuilder: (context, index) {
          final v = vacunaciones[index];

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: v["foto"] != null && v["foto"].toString().isNotEmpty
                ? Image.network(
                    v["foto"],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.pets),
              title: Text(v["nombre_mascota"] ?? ""),
              subtitle: Text(
                "${v["propietario"]}\n${v["tipo_mascota"]}",
              ),
              trailing: const Icon(Icons.edit),

              onTap: () async {
                final controller = TextEditingController(
                  text: v["observaciones"],
                );

                await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Editar observaciones"),
                    content: TextField(
                      controller: controller,
                      maxLines: 3,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancelar"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await Supabase.instance.client
                              .from("vacunaciones")
                              .update({
                                "observaciones": controller.text,
                              })
                              .eq("id", v["id"]);

                          if (!mounted) return;

                          Navigator.pop(context);
                          cargar();
                        },
                        child: const Text("Guardar"),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}