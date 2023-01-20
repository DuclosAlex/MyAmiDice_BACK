require('dotenv').config();
const express = require('express');
const router = require('./app/router/index');

const app = express();

app.use(express.json());

app.use(express.urlencoded({extended : true}));

app.use(router);

const port = process.env.PORT || 3000;

app.listen(port, () => {
    console.log(`http://localhost:${port}`);
});