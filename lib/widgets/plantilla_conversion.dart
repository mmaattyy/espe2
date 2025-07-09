import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlantillaConversion extends StatefulWidget {
  final String tipoConversion;
  final IconData icono;
  final String titulo;

  const PlantillaConversion({
    super.key,
    required this.tipoConversion,
    required this.icono,
    required this.titulo,
  });

  @override
  State<PlantillaConversion> createState() => _PlantillaConversionState();
}

class _PlantillaConversionState extends State<PlantillaConversion> {
  List<String> unidadesSI = [];
  List<String> unidadesNoSI = [];
  String unidadFrom = '';
  String unidadTo = '';
  final controlador = TextEditingController();

  String? resultado;
  bool cargando = false;
  String? error;
  bool cargandoUnidades = true;

  @override
  void initState() {
    super.initState();
    obtenerUnidades();
  }

  Future<void> obtenerUnidades() async {
    final uri = Uri.parse('http://10.0.2.2:3000/conversor/unidades/${widget.tipoConversion}');
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) throw Exception();

      final data = jsonDecode(response.body);
      final fetchedUnidadesRaw = List<Map<String, dynamic>>.from(data['unidades']);

      final siUnidades = fetchedUnidadesRaw.where((u) => u['si'] == true).map((u) => u['nombre'] as String).toList();
      final noSiUnidades = fetchedUnidadesRaw.where((u) => u['si'] == false).map((u) => u['nombre'] as String).toList();

      setState(() {
        unidadesSI = siUnidades;
        unidadesNoSI = noSiUnidades;
        unidadFrom = unidadesSI.isNotEmpty ? unidadesSI.first : (unidadesNoSI.isNotEmpty ? unidadesNoSI.first : '');
        unidadTo = (unidadesSI.length > 1) ? unidadesSI[1] : (unidadesNoSI.length > 1 ? unidadesNoSI[1] : unidadFrom);
        cargandoUnidades = false;
        error = null;
      });
    } catch (_) {
      setState(() {
        error = 'Error al cargar unidades.';
        cargandoUnidades = false;
      });
    }
  }

  Future<void> convertir() async {
    final valorTexto = controlador.text.replaceAll(',', '.');
    final valorNum = double.tryParse(valorTexto);

    if (valorTexto.isEmpty || unidadFrom == unidadTo || valorNum == null) {
      setState(() {
        error = valorTexto.isEmpty
            ? 'Ingrese un valor.'
            : unidadFrom == unidadTo
            ? 'Las unidades deben ser diferentes.'
            : 'Número inválido.';
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
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/conversor/convert'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tipo': widget.tipoConversion,
          'valor': valorNum,
          'unidadOrigen': unidadFrom,
          'unidadDestino': unidadTo,
        }),
      );

      if (response.statusCode != 200) throw Exception();

      final data = jsonDecode(response.body);
      final resRaw = data['resultado'];
      final resFormateado = (resRaw is num) ? resRaw.toDouble().toStringAsFixed(2) : resRaw.toString();

      // Guardar historial
      await http.post(
        Uri.parse('http://10.0.2.2:3000/historial'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'tipo': widget.tipoConversion,
          'valor_original': valorNum.toString(),
          'unidad_origen': unidadFrom,
          'unidad_destino': unidadTo,
          'resultado': resFormateado,
        }),
      );

      setState(() {
        resultado = resFormateado;
        cargando = false;
      });
    } catch (_) {
      setState(() {
        error = 'Error al conectar con el servidor.';
        cargando = false;
      });
    }
  }

  List<DropdownMenuItem<String>> _buildGroupedDropdownItems(List<String> si, List<String> noSi) {
    List<DropdownMenuItem<String>> buildItems(String label, List<String> units) {
      return [
        DropdownMenuItem<String>(
          enabled: false,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        ...units.map((u) => DropdownMenuItem(value: u, child: Padding(padding: const EdgeInsets.only(left: 16), child: Text(u)))),
      ];
    }

    return [
      if (si.isNotEmpty) ...buildItems('Sistema Internacional', si),
      if (noSi.isNotEmpty) ...buildItems('No SI', noSi),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary = Theme.of(context).colorScheme.primary;

    if (cargandoUnidades) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Valor en $unidadFrom',
                prefixIcon: Icon(widget.icono, color: colorPrimary),
                hintText: 'Ej: 12.5',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Desde:'),
            DropdownButton<String>(
              value: unidadFrom,
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: _buildGroupedDropdownItems(unidadesSI, unidadesNoSI),
              onChanged: (val) => val != null ? setState(() => unidadFrom = val) : null,
            ),
            const SizedBox(height: 24),
            const Center(child: Icon(Icons.arrow_downward, size: 32, color: Colors.grey)),
            const SizedBox(height: 24),
            const Text('Hasta:'),
            DropdownButton<String>(
              value: unidadTo,
              isExpanded: true,
              underline: const SizedBox(),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: _buildGroupedDropdownItems(unidadesSI, unidadesNoSI),
              onChanged: (val) => val != null ? setState(() => unidadTo = val) : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: cargando ? null : convertir,
              child: cargando ? const CircularProgressIndicator() : const Text('Convertir'),
            ),
            const SizedBox(height: 16),
            if (resultado != null)
              Text(
                'Resultado: $resultado $unidadTo',
                textAlign: TextAlign.center,
                style: TextStyle(color: colorPrimary, fontSize: 20),
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
}
