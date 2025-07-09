import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantillaConversion extends StatefulWidget {
  final String tipoConversion;
  final List<String> unidades;
  final IconData icono;
  final String titulo;

  const PlantillaConversion({
    super.key,
    required this.tipoConversion,
    required this.unidades,
    required this.icono,
    required this.titulo,
  });

  @override
  State<PlantillaConversion> createState() => _PlantillaConversionState();
}

class _PlantillaConversionState extends State<PlantillaConversion> {
  String unidadFrom = '';
  String unidadTo = '';
  final controlador = TextEditingController();

  String? resultado;
  bool cargando = false;
  String? error;

  @override
  void initState() {
    super.initState();
    unidadFrom = widget.unidades[0];
    unidadTo = widget.unidades[1];
  }

  Future<void> convertir() async {
    final valorTexto = controlador.text.replaceAll(',', '.'); // soporta coma

    if (valorTexto.isEmpty) {
      setState(() {
        error = 'Ingrese un valor para convertir.';
        resultado = null;
      });
      return;
    }

    if (unidadFrom == unidadTo) {
      setState(() {
        error = 'Las unidades no pueden ser iguales.';
        resultado = null;
      });
      return;
    }

    final valorNum = double.tryParse(valorTexto);
    if (valorNum == null) {
      setState(() {
        error = 'Ingrese un número válido.';
        resultado = null;
      });
      return;
    }

    setState(() {
      cargando = true;
      error = null;
      resultado = null;
    });

    try {
      final uri = Uri.parse('http://10.0.2.2:3000/conversor/convert');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tipo': widget.tipoConversion,
          'valor': valorNum,
          'unidadOrigen': unidadFrom,
          'unidadDestino': unidadTo,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final resultadoValor = data['resultado'].toString();

        // Guardar en historial
        final uriHistorial = Uri.parse('http://10.0.2.2:3000/historial');
        await http.post(
          uriHistorial,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'tipo': widget.tipoConversion,
            'valor_original': valorNum.toString(),
            'unidad_origen': unidadFrom,
            'unidad_destino': unidadTo,
            'resultado': resultadoValor,
          }),
        );

        setState(() {
          resultado = resultadoValor;
          cargando = false;
        });
      } else {
        setState(() {
          error = 'Error en la conversión: ${response.body}';
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error al conectar con el servidor.';
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary = Theme.of(context).colorScheme.primary;
    final colorOnSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titulo),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF00796B)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controlador,
              keyboardType: TextInputType.text,
              style: TextStyle(color: colorOnSurface),
              decoration: InputDecoration(
                labelText: unidadFrom,
                prefixIcon: Icon(widget.icono, color: colorPrimary),
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
                hintText: 'Ej: 12,5 o 12.5',
                hintStyle: const TextStyle(color: Color(0xFFB0BEC5)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Desde:', style: Theme.of(context).textTheme.bodyMedium),
            _buildDropdown(unidadFrom, (val) {
              setState(() {
                unidadFrom = val!;
              });
            }),
            const SizedBox(height: 24),
            Center(child: Icon(Icons.arrow_downward, size: 32, color: Colors.grey)),
            const SizedBox(height: 24),
            Text('Hasta:', style: Theme.of(context).textTheme.bodyMedium),
            _buildDropdown(unidadTo, (val) {
              setState(() {
                unidadTo = val!;
              });
            }),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cargando ? null : convertir,
                child: cargando
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Convertir'),
              ),
            ),
            const SizedBox(height: 16),
            if (resultado != null)
              Text(
                'Resultado: $resultado $unidadTo',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: colorPrimary),
                textAlign: TextAlign.center,
              ),
            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Atrás'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB2DFDB)),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: widget.unidades.map((u) {
          return DropdownMenuItem(value: u, child: Text(u));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
