import 'package:flutter/material.dart';
import 'pages/selector_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Unidades',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,

        // Fondo general
        scaffoldBackgroundColor: const Color(0xFFE0F7FA),

        // Paleta de colores principal y secundaria
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF00796B),
          onPrimary: Colors.white,
          secondary: Color(0xFFFF7043),
          onSecondary: Colors.white,
          background: Color(0xFFE0F7FA),
          onBackground: Color(0xFF263238),
          surface: Color(0xFFFFFFFF),
          onSurface: Color(0xFF263238),
          error: Colors.red,
          onError: Colors.white,
        ),

        // Estilo global para ElevatedButton
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00796B),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),

        // Estilo global para TextButton
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF00796B),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),

        // AppBar principal
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF00796B)),
          titleTextStyle: TextStyle(
            color: Color(0xFF263238),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Tipografía base
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Color(0xFF263238),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: Color(0xFF263238),
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF546E7A),
            fontSize: 14,
          ),
        ),
      ),
      home: const SelectorPage(),
    );
  }
}
