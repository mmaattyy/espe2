const express = require('express');
const cors = require('cors');

const app = express();
const port = 3000;

const converterRouter = require('./routes/converter');
const historyRouter = require('./routes/history');

app.use(cors());
app.use(express.json());

app.use('/conversor', converterRouter);
app.use('/historial', historyRouter);

app.listen(port, () => {
    console.log(`API escuchando en http://localhost:${port}`);
});
