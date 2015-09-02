cluster = require('cluster');
numCPUs = require('os').cpus().length;
http = require('http')

console.log 'using ' + numCPUs + ' cores...'

module.exports = (cb) ->
  if cluster.isMaster
    # Fork workers.
    i = 0
    while i < numCPUs
      cluster.fork()
      i++
    cluster.on 'exit', (worker, code, signal) ->
      console.log 'worker ' + worker.process.pid + ' died'
  else
    console.log 'created worker...'
    cb()

