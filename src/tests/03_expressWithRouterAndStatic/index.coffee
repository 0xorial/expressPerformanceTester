cluster = require('../common/cluster');

express = require 'express'

cluster ->
  app = express()
  router = express.Router()

  app.use(express.static(config.root))
  app.use('/', router)

  router.get '/', (req, res) ->
    res.send '<p>Hello world</p>'



