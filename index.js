require('dotenv').config();
const express = require('express');
const { characterRouter, userRouter, newsRouter } = require('./app/router');
const multer = require('multer');

const app = express();

app.use(express.json());

app.use(express.urlencoded({extended : true}));

const bodyParser = multer();

app.use(bodyParser.none());

app.use('/characters', characterRouter);
app.use('/users/', userRouter);
app.use('/news', newsRouter);

const port = process.env.PORT || 3000;

app.listen(port, () => {
    console.log(`http://localhost:${port}`);
});