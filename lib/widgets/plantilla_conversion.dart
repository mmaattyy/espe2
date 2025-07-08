import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantillaConversion extends StatefulWidget {
  final String titulo;
  final List<String> unidades;
  final IconData icono;
  final String tipoConversion;

  const PlantillaConversion({
    super.key,
    required this.titulo,
    required this.unidades,
    required this.icono,
    required this.tipoConversion,
  });

  @override
  State<PlantillaConversion> createState() => _PlantillaConversionState();
}

class _PlantillaConversionState extends State<PlantillaConversion> {
  late String unidadFrom;
  late String unidadTo;
  final controlador = TextEditingController();

  String? resultado;
  bool cargando = false;
  String? error;

  @override
  void initState() {
    super.initState();
    unidadFrom = widget.unidades.first;
    unidadTo = widget.unidades.length > 1 ? widget.unidades[1] : widget.unidades.first;
  }

  Future<void> convertir() async {
    final valorTexto = controlador.text;
    if (valorTexto.isEmpty) {
      setState(() {
        error = 'Ingrese un valor para convertir.';
        resultado = null;
      });
      return;
    }

    final valorNum = double.tryParse(valorTexto);
    if (valorNum == null) {
      setState(() {
        error = 'Ingrese un valor numérico válido.';
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
      final uri = Uri.parse('http://10.0.2.2:3000/conversor/convert'); // Cambia si usas otro host
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
        setState(() {
          resultado = data['resultado'].toString();
          cargando = false;
        });
      } else {
        setState(() {
          error = 'Error en la conversión: ${response.body}';
          cargando = false;
        });
      }
    } catch (_) {
      setState(() {
        error = 'Error al conectar con el servidor.';
        cargando = false;
      });
    }
  }

  Widget _buildDropdown(String label, String currentValue, ValueChanged<String?> onChanged) {
    final colorPrimary = Theme.of(context).colorScheme.primary;
    final colorOnSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFB2DFDB)),
          ),
          child: DropdownButton<String>(
            value: currentValue,
            isExpanded: true,
            underline: const SizedBox(),
            icon: Icon(Icons.keyboard_arrow_down, color: colorPrimary),
            items: widget.unidades
                .map((u) => DropdownMenuItem(
              value: u,
              child: Text(u, style: TextStyle(color: colorOnSurface)),
            ))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary = Theme.of(context).colorScheme.primary;
    final colorOnSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(widget.titulo, style: const TextStyle(color: Color(0xFF263238))),
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
                labelText: unidadFrom,
                labelStyle: const TextStyle(color: Color(0xFF546E7A)),
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
                hintText: 'Ingrese un valor',
                hintStyle: const TextStyle(color: Color(0xFFB0BEC5)),
              ),
            ),
            const SizedBox(height: 16),
            _buildDropdown('Desde:', unidadFrom, (val) {
              setState(() {
                unidadFrom = val!;
              });
            }),
            const SizedBox(height: 24),
            const Center(
              child: Icon(Icons.arrow_downward, size: 32, color: Color(0xFFB0BEC5)),
            ),
            const SizedBox(height: 24),
            _buildDropdown('Hasta:', unidadTo, (val) {
              setState(() {
                unidadTo = val!;
              });
            }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cargando ? null : convertir,
                child: cargando
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Convertir'),
              ),
            ),
            const SizedBox(height: 24),
            if (resultado != null)
              Text(
                'Resultado: $resultado $unidadTo',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: colorPrimary),
                textAlign: TextAlign.center,
              ),
            if (error != null)
              Text(
                error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
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
