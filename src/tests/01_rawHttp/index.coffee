http = require('http')
server = http.createServer((request, response) ->
  response.writeHead 200, 'Content-Type': 'text/plain'
  response.write 'loaderio-3c0e1d029c739bc1b3bb4698a05a42e6'
  response.end()
  return
)
server.listen 80
