import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../theme/app_theme.dart';

class CrearUsuarioScreen extends StatefulWidget {
  final String? rolFijo;
  final dynamic sectorFijoId;

  const CrearUsuarioScreen({
    super.key,
    this.rolFijo,
    this.sectorFijoId,
  });

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

  @override
  void initState() {
    super.initState();

    if (widget.rolFijo != null) {
      rol = widget.rolFijo!;
    }
  }

  Future<void> crearUsuario() async {
    try {
      setState(() => loading = true);

      final auth = await Supabase.instance.client.auth.signUp(
        email: correo.text.trim(),
        password: "Ecuador2026",
      );

      final userId = auth.user!.id;

      final nuevoUsuario = {
        "id": userId,
        "cedula": cedula.text.trim(),
        "nombres": nombres.text.trim(),
        "apellidos": apellidos.text.trim(),
        "telefono": telefono.text.trim(),
        "correo": correo.text.trim(),
        "rol": rol,
      };

      if (widget.sectorFijoId != null) {
        nuevoUsuario["sector_id"] = widget.sectorFijoId;
      }

      await Supabase.instance.client.from('usuarios').insert(nuevoUsuario);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            rol == "vacunador"
                ? "Vacunador creado correctamente"
                : "Usuario creado correctamente",
          ),
        ),
      );

      cedula.clear();
      nombres.clear();
      apellidos.clear();
      telefono.clear();
      correo.clear();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al crear usuario: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void dispose() {
    cedula.dispose();
    nombres.dispose();
    apellidos.dispose();
    telefono.dispose();
    correo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titulo = rol == "vacunador" ? "Crear vacunador" : "Crear usuario";

    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: cedula,
              decoration: const InputDecoration(
                labelText: "Cédula",
                prefixIcon: Icon(Icons.badge_outlined),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: nombres,
              decoration: const InputDecoration(
                labelText: "Nombres",
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: apellidos,
              decoration: const InputDecoration(
                labelText: "Apellidos",
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: telefono,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Teléfono",
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: correo,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Correo",
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),

            const SizedBox(height: 14),

            if (widget.rolFijo == null)
              DropdownButtonFormField<String>(
                value: rol,
                decoration: const InputDecoration(
                  labelText: "Rol",
                  prefixIcon: Icon(Icons.assignment_ind_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: "brigada", child: Text("Brigada")),
                  DropdownMenuItem(value: "vacunador", child: Text("Vacunador")),
                ],
                onChanged: (value) {
                  setState(() {
                    rol = value!;
                  });
                },
              )
            else
  Card(
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.sky,
        child: Icon(
          rol == "brigada" ? Icons.groups_outlined : Icons.vaccines,
          color: AppColors.navy,
        ),
      ),
      title: const Text(
        "Rol",
        style: TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        rol == "brigada" ? "Brigada" : "Vacunador",
      ),
    ),
  ),

            const SizedBox(height: 22),

            ElevatedButton.icon(
              onPressed: loading ? null : crearUsuario,
              icon: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(loading ? "Creando..." : titulo),
            ),
          ],
        ),
      ),
    );
  }
}