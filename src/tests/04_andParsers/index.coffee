
express = require 'express'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
session = require 'express-session'

app = express()
router = express.Router()

app.use(express.static('../common/'))
app.use(cookieParser())
app.use(bodyParser.json())
app.use(session({
    name: 'test_session'
    secret: 'cat keyboard'
    resave: false
    saveUninitialized: false
    }))
app.use('/', router)

router.get '/', (req, res) ->
  res.send '<p>Hello world</p>'


cluster = require('../common/cluster');
cluster ->
  app.listen(80)
