# Conversor de Unidades Flutter con Backend Node.js

Este proyecto consiste en una aplicación móvil desarrollada en Flutter que
permite convertir valores entre diferentes unidades de medida. La app se comunica con un backend REST API construido en Node.js y Express, que realiza las conversiones y maneja el historial de conversiones almacenado en una base de datos MySQL.

---

## Requerimientos

- **Flutter**: Para la interfaz de usuario móvil y las vistas de conversión e historial.
- **Node.js + Express**: Backend para procesar las conversiones y manejar la persistencia de datos.
- **MySQL**: Base de datos para almacenar el historial de conversiones.
- **HTTP**: Comunicación entre la app Flutter y la API REST mediante peticiones HTTP.

---

## Funcionalidades principales

- Conversión entre múltiples unidades de:
    - Volumen (mililitro, litro, galón, metro cúbico, etc.)
    - Temperatura (Celsius, Fahrenheit, Kelvin)
    - Medidas métricas (metro, kilómetro, centímetro, etc.)
    - Velocidad (km/h, mph, m/s, nudos)

- Obtención dinámica de unidades soportadas desde la API para cada tipo de conversión.

- Validación y formateo de resultados con hasta dos decimales.

- Almacenamiento del historial de conversiones en la base de datos.

- Visualización del historial en la app con opción para borrar todo el historial.

---

## Cómo usar

1. Configurar y levantar la base de datos MySQL.
2. Ejecutar el backend Node.js con `npm start` o `node index.js`.
3. Ejecutar la app Flutter en un emulador o dispositivo físico.
4. Realizar conversiones y visualizar el historial.

---

## Notas

- La app asume que la API corre en `http://10.0.2.2:3000` (localhost para emulador Android).
- Para producción, ajustar las URLs y configuraciones necesarias.
