const express = require('express');
const router = express.Router();

const conversionFormulas = {
    Volumen: {
        'Metro cúbico': {
            'Kilómetro cúbico': (v) => v / 1e9,
            'Hectómetro cúbico': (v) => v / 1e6,
            'Decámetro cúbico': (v) => v / 1e3,
            'Decímetro cúbico': (v) => v * 1e3,
            'Centímetro cúbico': (v) => v * 1e6,
            'Milímetro cúbico': (v) => v * 1e9,
            Litro: (v) => v * 1000,
            Galón: (v) => v * 264.172, // galón US líquido
            Pinta: (v) => v * 2113.38,
            'Pie cúbico': (v) => v * 35.3147,
            'Onza líquida': (v) => v * 33814,
            'Metro cúbico': (v) => v,
        },
        'Kilómetro cúbico': {
            'Metro cúbico': (v) => v * 1e9,
            'Kilómetro cúbico': (v) => v,
        },
        'Hectómetro cúbico': {
            'Metro cúbico': (v) => v * 1e6,
            'Hectómetro cúbico': (v) => v,
        },
        'Decámetro cúbico': {
            'Metro cúbico': (v) => v * 1e3,
            'Decámetro cúbico': (v) => v,
        },
        'Decímetro cúbico': { // igual a litro
            'Metro cúbico': (v) => v / 1e3,
            'Litro': (v) => v,
            'Mililitro': (v) => v * 1000,
            'Decímetro cúbico': (v) => v,
        },
        Litro: {
            'Metro cúbico': (v) => v / 1000,
            'Mililitro': (v) => v * 1000,
            Litro: (v) => v,
            Galón: (v) => v / 3.78541,
            Pinta: (v) => v * 2.11338,
            'Onza líquida': (v) => v * 33.814,
        },
        Mililitro: {
            'Metro cúbico': (v) => v / 1e6,
            Litro: (v) => v / 1000,
            Mililitro: (v) => v,
        },
        'Centímetro cúbico': {
            'Metro cúbico': (v) => v / 1e6,
            'Centímetro cúbico': (v) => v,
        },
        'Milímetro cúbico': {
            'Metro cúbico': (v) => v / 1e9,
            'Milímetro cúbico': (v) => v,
        },
        Galón: {
            'Metro cúbico': (v) => v / 264.172,
            Litro: (v) => v * 3.78541,
            Galón: (v) => v,
        },
        Pinta: {
            'Metro cúbico': (v) => v / 2113.38,
            Litro: (v) => v / 2.11338,
            Pinta: (v) => v,
        },
        'Pie cúbico': {
            'Metro cúbico': (v) => v / 35.3147,
            'Pie cúbico': (v) => v,
        },
        'Onza líquida': {
            'Metro cúbico': (v) => v / 33814,
            Litro: (v) => v / 33.814,
            'Onza líquida': (v) => v,
        },
    },

    Temperatura: {
        Celsius: {
            Fahrenheit: (v) => (v * 9) / 5 + 32,
            Kelvin: (v) => v + 273.15,
            Celsius: (v) => v,
        },
        Fahrenheit: {
            Celsius: (v) => ((v - 32) * 5) / 9,
            Kelvin: (v) => ((v - 32) * 5) / 9 + 273.15,
            Fahrenheit: (v) => v,
        },
        Kelvin: {
            Celsius: (v) => v - 273.15,
            Fahrenheit: (v) => ((v - 273.15) * 9) / 5 + 32,
            Kelvin: (v) => v,
        },
    },

    Métrica: {
        Metro: {
            Kilómetro: (v) => v / 1000,
            Centímetro: (v) => v * 100,
            Milímetro: (v) => v * 1000,
            Pulgada: (v) => v / 0.0254,
            Pie: (v) => v / 0.3048,
            Yarda: (v) => v / 0.9144,
            Milla: (v) => v / 1609.34,
            Metro: (v) => v,
        },
        Kilómetro: {
            Metro: (v) => v * 1000,
            Milla: (v) => v / 1.60934,
            Kilómetro: (v) => v,
        },
        Centímetro: {
            Metro: (v) => v / 100,
            Centímetro: (v) => v,
        },
        Milímetro: {
            Metro: (v) => v / 1000,
            Milímetro: (v) => v,
        },
        Pulgada: {
            Metro: (v) => v * 0.0254,
            Pulgada: (v) => v,
        },
        Pie: {
            Metro: (v) => v * 0.3048,
            Pie: (v) => v,
        },
        Yarda: {
            Metro: (v) => v * 0.9144,
            Yarda: (v) => v,
        },
        Milla: {
            Metro: (v) => v * 1609.34,
            Milla: (v) => v,
        },
    },

    Velocidad: {
        'Kilómetros por hora': {
            'Millas por hora': (v) => v * 0.621371,
            'Metros por segundo': (v) => v / 3.6,
            'Nudos': (v) => v / 1.852,
            'Kilómetros por hora': (v) => v,
        },
        'Millas por hora': {
            'Kilómetros por hora': (v) => v / 0.621371,
            'Metros por segundo': (v) => (v / 0.621371) / 3.6,
            'Nudos': (v) => (v * 1.60934) / 1.852,
            'Millas por hora': (v) => v,
        },
        'Metros por segundo': {
            'Kilómetros por hora': (v) => v * 3.6,
            'Millas por hora': (v) => (v * 3.6) * 0.621371,
            'Nudos': (v) => (v * 3.6) / 1.852,
            'Metros por segundo': (v) => v,
        },
        Nudos: {
            'Kilómetros por hora': (v) => v * 1.852,
            'Millas por hora': (v) => (v * 1.852) * 0.621371,
            'Metros por segundo': (v) => (v * 1.852) / 3.6,
            Nudos: (v) => v,
        },
    },
};

// Ruta de conversión
router.post('/convert', (req, res) => {
    const { tipo, valor, unidadOrigen, unidadDestino } = req.body;

    if (!tipo || valor === undefined || !unidadOrigen || !unidadDestino) {
        return res.status(400).json({ error: 'Faltan datos para conversión' });
    }

    const valorNum = parseFloat(valor);
    if (isNaN(valorNum)) {
        return res.status(400).json({ error: 'Valor debe ser numérico' });
    }

    const formulasTipo = conversionFormulas[tipo];
    if (!formulasTipo) {
        return res.status(400).json({ error: 'Tipo de conversión no soportado' });
    }

    const formulasOrigen = formulasTipo[unidadOrigen];
    if (!formulasOrigen) {
        return res.status(400).json({ error: 'Unidad origen no soportada' });
    }

    const formula = formulasOrigen[unidadDestino];
    if (!formula) {
        return res.status(400).json({ error: 'Unidad destino no soportada' });
    }

    const resultado = formula(valorNum);
    res.json({ resultado });
});

// Ruta para obtener unidades con flag "si" para SI
router.get('/unidades/:tipo', (req, res) => {
    const tipo = req.params.tipo;
    const formulasTipo = conversionFormulas[tipo];
    if (!formulasTipo) {
        return res.status(404).json({ error: 'Tipo no encontrado' });
    }

    // Definición de unidades SI para cada tipo
    const siUnitsByType = {
        Volumen: ['Mililitro', 'Litro', 'Metro cúbico', 'Kilómetro cúbico', 'Hectómetro cúbico', 'Decámetro cúbico', 'Decímetro cúbico', 'Centímetro cúbico', 'Milímetro cúbico'],
        Temperatura: ['Celsius', 'Kelvin'],
        Métrica: ['Metro', 'Kilómetro', 'Centímetro', 'Milímetro'],
        Velocidad: ['Metros por segundo', 'Kilómetros por hora'],
    };

    const unidades = Object.keys(formulasTipo).map((unidad) => ({
        nombre: unidad,
        si: siUnitsByType[tipo]?.includes(unidad) || false,
    }));

    res.json({ unidades });
});

module.exports = router;
