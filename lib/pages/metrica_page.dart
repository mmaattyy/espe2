import 'package:flutter/material.dart';
import '../widgets/plantilla_conversion.dart';

class MetricaPage extends StatelessWidget {
  const MetricaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlantillaConversion(
      titulo: 'Métrica',
      icono: Icons.straighten,
      tipoConversion: 'Métrica',
    );
  }
}
