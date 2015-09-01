cluster = require('cluster');
numCPUs = require('os').cpus().length;
http = require('http')

console.log 'using ' + numCPUs + ' cores...'

if cluster.isMaster
  # Fork workers.
  i = 0
  while i < numCPUs
    cluster.fork()
    i++
  cluster.on 'exit', (worker, code, signal) ->
    console.log 'worker ' + worker.process.pid + ' died'
    return
else
  console.log 'created server...'
  # Workers can share any TCP connection
  # In this case its a HTTP server
  http.createServer((req, res) ->
    res.writeHead 200
    res.end 'loaderio-3c0e1d029c739bc1b3bb4698a05a42e6'
    return
  ).listen 80


