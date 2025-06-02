import 'package:flutter/material.dart';
import 'temperatura_page.dart';
import 'volumen_page.dart';

class SelectorPage extends StatelessWidget {
  const SelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xE5F6FBFF),
      appBar: AppBar(
        title: const Text('Selector de unidades'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(onPressed: () {}, child: const Text("About"))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Seleccione conversión', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _opcion(context, Icons.attach_money, 'Moneda', () {}),
                _opcion(context, Icons.local_drink, 'Volumen', () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => VolumenPage()));
                }),
                _opcion(context, Icons.thermostat, 'Temperatura', () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => TemperaturaPage()));
                }),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _opcion(context, Icons.swap_horiz, 'UF', () {}),
                _opcion(context, Icons.straighten, 'Métrica', () {}),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              child: const Text('Historial'),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }

  Widget _opcion(BuildContext ctx, IconData icono, String texto, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(radius: 32, child: Icon(icono, size: 32)),
          const SizedBox(height: 8),
          Text(texto),
        ],
      ),
    );
  }
}
