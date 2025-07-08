import 'package:flutter/material.dart';
import '../widgets/plantilla_conversion.dart';

class VolumenPage extends StatelessWidget {
  const VolumenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlantillaConversion(
      titulo: 'Volumen',
      unidades: ['Mililitro', 'Litro', 'Galón'],
      icono: Icons.invert_colors,
      tipoConversion: 'Volumen',
    );
  }
}
