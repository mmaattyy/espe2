import 'package:flutter/material.dart';
import 'temperatura_page.dart';
import 'volumen_page.dart';
import 'metrica_page.dart';
import 'velocidad_page.dart';
import 'historial_page.dart';

class SelectorPage extends StatelessWidget {
  const SelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorPrimary = Theme.of(context).colorScheme.primary;
    final colorOnSurface = Theme.of(context).colorScheme.onSurface;
    final colorSecondary = Theme.of(context).colorScheme.secondary;

    final options = [
      _OptionData('Moneda', Icons.attach_money, () {
        // Navegación pendiente para Moneda
      }),
      _OptionData('Volumen', Icons.local_drink, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VolumenPage()),
        );
      }),
      _OptionData('Temperatura', Icons.thermostat, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TemperaturaPage()),
        );
      }),
      _OptionData('UF', Icons.swap_horiz, () {
        // Navegación pendiente para UF
      }),
      _OptionData('Métrica', Icons.straighten, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MetricaPage()),
        );
      }),
      _OptionData('Velocidad', Icons.speed, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VelocidadPage()),
        );
      }),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Selector de Unidades'),
        actions: [
          TextButton(
            onPressed: () {
              // Acción “About” pendiente
            },
            child: const Text("About"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(
              '¿Qué desea convertir?',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 1.2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: options.map((opt) {
                return _buildCard(
                  context,
                  opt,
                  colorPrimary,
                  colorOnSurface,
                  colorSecondary,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistorialPage()),
                  );
                },
                icon: const Icon(Icons.history),
                label: const Text('Ver Historial'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context,
      _OptionData data,
      Color colorPrimary,
      Color textColor,
      Color splashColor,
      ) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: data.onTap,
        splashColor: splashColor.withOpacity(0.2),
        highlightColor: splashColor.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                data.icon,
                size: 48,
                color: colorPrimary,
              ),
              const SizedBox(height: 16),
              Text(
                data.label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionData {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  _OptionData(this.label, this.icon, this.onTap);
}
