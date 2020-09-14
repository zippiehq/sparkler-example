import express from 'express'
import cors from 'cors'
import Router from 'express-promise-router'
import bodyParser from 'body-parser'
import crypto from 'crypto'
import fs from 'fs'
import Redis from 'ioredis'

const mmds = JSON.parse(fs.readFileSync(process.env['MMDS_FILE'] ? process.env['MMDS_FILE'] : 'mmds.json')).latest.sparkler

let secrets

const app = express()
const router = new Router();

app.use(cors())
app.use(bodyParser.json())
app.use(bodyParser.urlencoded({
    extended: true
}));

app.use(router)

router.get('/health', async function (req, res) {
    res.send({ health: 'ok' })
})


async function init() {
    const port = process.env.PORT || 8099

    const server = app.listen(port, '0.0.0.0', function () {
        console.log('app listening at http://%s:%s', server.address().address, server.address().port)
    })
}

init()
