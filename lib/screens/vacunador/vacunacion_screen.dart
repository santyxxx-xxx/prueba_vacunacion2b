import 'dart:io';
import '../../widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VacunacionScreen extends StatefulWidget {
  const VacunacionScreen({super.key});

  @override
  State<VacunacionScreen> createState() => _VacunacionScreenState();
}

class _VacunacionScreenState extends State<VacunacionScreen> {
  final propietario = TextEditingController();
  final cedula = TextEditingController();
  final telefono = TextEditingController();
  final nombreMascota = TextEditingController();
  final edad = TextEditingController();
  final vacuna = TextEditingController();
  final observaciones = TextEditingController();

  String tipoMascota = "Perro";
  String sexo = "Macho";

  File? imagen;

  double? latitud;
  double? longitud;

  bool loading = false;

  Future<void> tomarFoto() async {
    final picker = ImagePicker();

    final foto = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (foto == null) return;

    setState(() {
      imagen = File(foto.path);
    });
  }

  Future<void> obtenerGPS() async {
    bool servicio = await Geolocator.isLocationServiceEnabled();

    if (!servicio) return;

    var permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    Position posicion = await Geolocator.getCurrentPosition();

    latitud = posicion.latitude;
    longitud = posicion.longitude;
  }

  Future<String> subirImagen() async {
    if (imagen == null) return "";

    final nombre =
        "${DateTime.now().millisecondsSinceEpoch}.jpg";

    await Supabase.instance.client.storage
        .from("fotos")
        .upload(nombre, imagen!);

    return Supabase.instance.client.storage
        .from("fotos")
        .getPublicUrl(nombre);
  }

  Future<void> guardar() async {
  try {
    setState(() => loading = true);

    await obtenerGPS();

    final foto = await subirImagen();

    final user = Supabase.instance.client.auth.currentUser;

    await Supabase.instance.client.from("vacunaciones").insert({
      "propietario": propietario.text,
      "cedula": cedula.text,
      "telefono": telefono.text,
      "tipo_mascota": tipoMascota,
      "nombre_mascota": nombreMascota.text,
      "edad": edad.text,
      "sexo": sexo,
      "vacuna": vacuna.text,
      "observaciones": observaciones.text,
      "foto": foto,
      "latitud": latitud,
      "longitud": longitud,
      "vacunador_id": user!.id,
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Vacunación registrada")),
    );

    Navigator.pop(context);

  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  } finally {
    if (mounted) {
      setState(() => loading = false);
    }
  }
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
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: propietario,
            decoration: const InputDecoration(
              labelText: "Propietario",
            ),
          ),

          TextField(
            controller: cedula,
            decoration: const InputDecoration(
              labelText: "Cédula",
            ),
          ),

          TextField(
            controller: telefono,
            decoration: const InputDecoration(
              labelText: "Teléfono",
            ),
          ),

          DropdownButtonFormField(
            value: tipoMascota,
            items: const [
              DropdownMenuItem(
                value: "Perro",
                child: Text("Perro"),
              ),
              DropdownMenuItem(
                value: "Gato",
                child: Text("Gato"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                tipoMascota = value!;
              });
            },
          ),

          TextField(
            controller: nombreMascota,
            decoration: const InputDecoration(
              labelText: "Nombre mascota",
            ),
          ),

          TextField(
            controller: edad,
            decoration: const InputDecoration(
              labelText: "Edad aproximada",
            ),
          ),

          DropdownButtonFormField(
            value: sexo,
            items: const [
              DropdownMenuItem(
                value: "Macho",
                child: Text("Macho"),
              ),
              DropdownMenuItem(
                value: "Hembra",
                child: Text("Hembra"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                sexo = value!;
              });
            },
          ),

          TextField(
            controller: vacuna,
            decoration: const InputDecoration(
              labelText: "Vacuna",
            ),
          ),

          TextField(
            controller: observaciones,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Observaciones",
            ),
          ),

          const SizedBox(height: 20),

          if (imagen != null)
            Image.file(
              imagen!,
              height: 180,
            ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: tomarFoto,
            child: const Text("Tomar Foto"),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: loading ? null : guardar,
            child: const Text("Guardar"),
          ),
        ],
      ),
    ),
  );
}
}