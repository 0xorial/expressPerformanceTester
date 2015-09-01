buildDist = require('./src/tests-distributable-build').build

ssh = null

buildDist()
.then ->
  Ssh = require('./src/ssh')
  ip = require('fs').readFileSync('./config/server-ip', 'utf-8')
  ssh = new Ssh(ip)
  ssh.connect()
.then ->
  ssh.exec('uptime')
.then ->
  ssh.disconnect()
