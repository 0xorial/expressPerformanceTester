express = require 'express'

app = express()
router = express.Router()

app.use(express.static('../common/'))
app.use('/', router)

router.get '/', (req, res) ->
  res.send '<p>Hello world</p>'

cluster = require('../common/cluster');
cluster ->
  app.listen(80)
