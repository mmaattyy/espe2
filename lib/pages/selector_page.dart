import 'package:flutter/material.dart';
import 'temperatura_page.dart';
import 'volumen_page.dart';
import 'historial_page.dart'; // Asegúrate de tener esta vista creada

class SelectorPage extends StatelessWidget {
  const SelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final opciones = [
      _Opcion('Moneda', Icons.attach_money, null),
      _Opcion('Volumen', Icons.local_drink, const VolumenPage()),
      _Opcion('Temperatura', Icons.thermostat, const TemperaturaPage()),
      _Opcion('UF', Icons.swap_horiz, null),
      _Opcion('Métrica', Icons.straighten, null),
      _Opcion('Velocidad', Icons.speed, null),
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
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
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.2,
              ),
              itemCount: opciones.length,
              itemBuilder: (context, index) {
                final opt = opciones[index];
                return _OpcionCard(opcion: opt);
              },
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
}

class _Opcion {
  final String nombre;
  final IconData icono;
  final Widget? destino;

  const _Opcion(this.nombre, this.icono, this.destino);
}

class _OpcionCard extends StatelessWidget {
  final _Opcion opcion;

  const _OpcionCard({required this.opcion});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      shadowColor: Colors.black.withOpacity(0.12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: theme.colorScheme.secondary.withOpacity(0.2),
        highlightColor: theme.colorScheme.secondary.withOpacity(0.1),
        onTap: opcion.destino != null
            ? () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => opcion.destino!),
        )
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(opcion.icono, size: 48, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                opcion.nombre,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
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
