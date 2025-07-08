import 'package:flutter/material.dart';
import '../widgets/plantilla_conversion.dart';

class TemperaturaPage extends StatelessWidget {
  const TemperaturaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlantillaConversion(
      titulo: 'Temperatura',
      unidades: ['Fahrenheit', 'Celsius', 'Kelvin'],
      icono: Icons.thermostat,
      tipoConversion: 'Temperatura',
    );
  }
}
