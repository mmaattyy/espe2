import 'package:flutter/material.dart';

class VolumenPage extends StatefulWidget {
  const VolumenPage({super.key});

  @override
  State<VolumenPage> createState() => _VolumenPageState();
}

class _VolumenPageState extends State<VolumenPage> {
  String unidadFrom = 'Mililitro';
  String unidadTo = 'Litro';
  final unidades = ['Mililitro', 'Litro', 'Galón'];
  final controlador = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE5F6FBFF),
      appBar: AppBar(
        title: const Text('Volumen'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(onPressed: () {}, child: const Text("About"))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            TextField(
              controller: controlador,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: unidadFrom),
            ),
            DropdownButton<String>(
              value: unidadFrom,
              items: unidades.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (val) => setState(() => unidadFrom = val!),
            ),
            const SizedBox(height: 20),
            const Icon(Icons.arrow_downward),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: unidadTo,
              items: unidades.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (val) => setState(() => unidadTo = val!),
            ),
            const SizedBox(height: 8),
            const Text('A', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Fórmula:', style: TextStyle(fontSize: 16)),
            const Spacer(),
            ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Atras')
            )
          ],
        ),
      ),
    );
  }
}
