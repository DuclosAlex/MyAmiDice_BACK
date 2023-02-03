require('dotenv').config();
const express = require('express');
const cors = require('cors');

const { characterRouter, userRouter, newsRouter, gameRouter, itemRouter, skillRouter, mapRouter, inviteRouter, characteristicRouter } = require('./app/router');
const multer = require('multer');

const app = express();
app.use(cors());

app.use(express.json());
app.use(express.urlencoded({extended : true}));

app.use('/', express.static('public'));

const bodyParser = multer();

app.use(bodyParser.none());

app.use('/characters', characterRouter);
app.use('/users', userRouter);
app.use('/news', newsRouter);
app.use('/games', gameRouter);
app.use('/items', itemRouter);
app.use('/skills', skillRouter);
app.use('/maps', mapRouter);
app.use('/invites', inviteRouter);
app.use('/characteristics', characteristicRouter);

const port = process.env.PORT || 3000;

app.listen(port, () => {
    console.log(`http://localhost:${port}`);
});