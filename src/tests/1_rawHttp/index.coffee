class exports.Server
  constructor: (@options) ->

  start: ->
    http = require('http')
    @server = http.createServer((request, response) ->
      response.writeHead 200, 'Content-Type': 'text/plain'
      response.write 'hello world!'
      response.end()
      return
    )
    @server.listen 80
    return

  stop: ->
    @server.stop()
