import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  List<dynamic> historial = [];
  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    obtenerHistorial();
  }

  Future<void> obtenerHistorial() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final uri = Uri.parse('http://10.0.2.2:3000/historial');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          historial = data;
          cargando = false;
        });
      } else {
        setState(() {
          error = 'Error al obtener historial: ${response.body}';
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'No se pudo conectar al servidor.';
        cargando = false;
      });
    }
  }

  Future<void> borrarHistorial() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final uri = Uri.parse('http://10.0.2.2:3000/historial');
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        setState(() {
          historial.clear();
          cargando = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Historial borrado correctamente')),
        );
      } else {
        setState(() {
          error = 'Error al borrar historial: ${response.body}';
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'No se pudo conectar al servidor.';
        cargando = false;
      });
    }
  }

  String formatearFecha(String fechaStr) {
    try {
      final fecha = DateTime.parse(fechaStr);
      final formato = DateFormat('dd/MM/yyyy HH:mm');
      return formato.format(fecha);
    } catch (e) {
      return fechaStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Conversiones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Borrar historial',
            onPressed: historial.isEmpty || cargando
                ? null
                : () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirmar borrado'),
                  content: const Text('¿Seguro que quieres borrar todo el historial?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Borrar'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await borrarHistorial();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: cargando
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
            : historial.isEmpty
            ? const Center(child: Text('No hay conversiones registradas.'))
            : ListView.builder(
          itemCount: historial.length,
          itemBuilder: (context, index) {
            final item = historial[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.swap_horiz),
                title: Text(
                  '${item['valor_original']} ${item['unidad_origen']} → ${item['resultado']} ${item['unidad_destino']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${item['tipo']} | ${formatearFecha(item['fecha'])}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
