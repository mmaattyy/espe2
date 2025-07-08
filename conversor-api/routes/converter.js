const express = require('express');
const router = express.Router();

const conversionFormulas = {
    Volumen: {
        Mililitro: {
            Litro: (v) => v / 1000,
            Galón: (v) => v / 3785.41,
            Mililitro: (v) => v,
        },
        Litro: {
            Mililitro: (v) => v * 1000,
            Galón: (v) => v / 3.78541,
            Litro: (v) => v,
        },
        Galón: {
            Mililitro: (v) => v * 3785.41,
            Litro: (v) => v * 3.78541,
            Galón: (v) => v,
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
    // Puedes añadir más tipos y unidades aquí
};

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

module.exports = router;
