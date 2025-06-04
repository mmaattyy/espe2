import 'package:flutter/material.dart';

class TemperaturaPage extends StatefulWidget {
  const TemperaturaPage({super.key});

  @override
  State<TemperaturaPage> createState() => _TemperaturaPageState();
}

class _TemperaturaPageState extends State<TemperaturaPage> {
  String unidadFrom = 'Fahrenheit';
  String unidadTo = 'Celsius';
  final unidades = ['Fahrenheit', 'Celsius', 'Kelvin'];
  final controlador = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colorPrimary = Theme.of(context).colorScheme.primary;
    final colorOnSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'Temperatura',
          style: TextStyle(color: Color(0xFF263238)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              // Acción “About” pendiente
            },
            child: const Text("About"),
          )
        ],
        iconTheme: const IconThemeData(color: Color(0xFF00796B)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controlador,
              keyboardType: TextInputType.number,
              style: TextStyle(color: colorOnSurface),
              decoration: InputDecoration(
                labelText: '°$unidadFrom',
                labelStyle: TextStyle(color: const Color(0xFF546E7A)),
                prefixIcon: Icon(Icons.thermostat, color: colorPrimary),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Color(0xFFB2DFDB)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Color(0xFFB2DFDB), width: 2),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Ingrese un valor',
                hintStyle: TextStyle(color: const Color(0xFFB0BEC5)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Desde:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFB2DFDB)),
              ),
              child: DropdownButton<String>(
                value: unidadFrom,
                isExpanded: true,
                underline: const SizedBox(),
                icon: Icon(Icons.keyboard_arrow_down, color: colorPrimary),
                items: unidades
                    .map((u) => DropdownMenuItem(
                  value: u,
                  child: Text(u, style: TextStyle(color: colorOnSurface)),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    unidadFrom = val!;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Icon(
                Icons.arrow_downward,
                size: 32,
                color: const Color(0xFFB0BEC5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Hasta:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFB2DFDB)),
              ),
              child: DropdownButton<String>(
                value: unidadTo,
                isExpanded: true,
                underline: const SizedBox(),
                icon: Icon(Icons.keyboard_arrow_down, color: colorPrimary),
                items: unidades
                    .map((u) => DropdownMenuItem(
                  value: u,
                  child: Text(u, style: TextStyle(color: colorOnSurface)),
                ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    unidadTo = val!;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'A',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Fórmula: (([De °F] − 32) × 5/9 = [a °C])',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Atrás'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
