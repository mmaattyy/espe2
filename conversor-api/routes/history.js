const express = require('express');
const router = express.Router();
const pool = require('../db');

router.post('/', async (req, res) => {
    const { tipo, valor_original, unidad_origen, unidad_destino, resultado } = req.body;
    if (!tipo || !valor_original || !unidad_origen || !unidad_destino || !resultado) {
        return res.status(400).json({ error: 'Faltan campos obligatorios' });
    }

    try {
        const query = `
          INSERT INTO historial (tipo, valor_original, unidad_origen, unidad_destino, resultado)
          VALUES (?, ?, ?, ?, ?)
        `;
        await pool.execute(query, [tipo, valor_original, unidad_origen, unidad_destino, resultado]);
        res.status(201).json({ message: 'Conversión guardada correctamente' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al guardar en la base de datos' });
    }
});

router.get('/', async (req, res) => {
    try {
        const [rows] = await pool.execute('SELECT * FROM historial ORDER BY fecha DESC');
        res.json(rows);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al obtener historial' });
    }
});

router.delete('/', async (req, res) => {
    try {
        await pool.execute('DELETE FROM historial');
        res.json({ message: 'Historial borrado correctamente' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al borrar historial' });
    }
});

module.exports = router;
