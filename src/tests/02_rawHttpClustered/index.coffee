cluster = require('../common/cluster');

cluster ->
  http.createServer((req, res) ->
    res.writeHead 200
    res.end 'loaderio-3c0e1d029c739bc1b3bb4698a05a42e6'
    return
  ).listen 80


