# gulp = require('gulp').parse('./gulpfile')

Client = require('ssh2').Client
Ssh = require('./src/ssh')

ip = require('fs').readFileSync('./config/server-ip', 'utf-8')
ssh = new Ssh(ip)
ssh.connect()
.then ->
  ssh.exec('uptime')
.finally ->
  ssh.disconnect()
