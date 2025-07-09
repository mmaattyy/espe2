import 'package:flutter/material.dart';
import '../widgets/plantilla_conversion.dart';

class VelocidadPage extends StatelessWidget {
  const VelocidadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlantillaConversion(
      tipoConversion: 'Velocidad',
      icono: Icons.speed,
      titulo: 'Velocidad',
    );
  }
}
