import 'package:flutter/material.dart';
import 'vacunacion_screen.dart';
import 'lista_vacunaciones_screen.dart';
import '../../widgets/logout_button.dart';
import '../../theme/app_theme.dart';

class VacunadorScreen extends StatelessWidget {
  const VacunadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vacunador"),
        actions: const [
          LogoutButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.vaccines,
              size: 76,
              color: AppColors.navy,
            ),

            const SizedBox(height: 16),

            const Text(
              "Panel de vacunación",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.navy,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Registra nuevas vacunas o revisa las vacunaciones guardadas.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.text,
              ),
            ),

            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VacunacionScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text("Registrar vacunación"),
            ),

            const SizedBox(height: 14),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ListaVacunacionesScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.list_alt),
              label: const Text("Ver vacunaciones"),
            ),
          ],
        ),
      ),
    );
  }
}