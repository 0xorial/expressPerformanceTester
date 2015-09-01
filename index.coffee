buildDist = require('./src/tests-distributable-build').build

ip = require('fs').readFileSync('./config/server-ip', 'utf-8')


ssh = null

buildDist()
.then ->
  scp = require './src/scp'
  return scp.copy(ip, './build/dist.tar.gz', '/root/')
.then ->
  Ssh = require('./src/ssh')
  ssh = new Ssh(ip)
  return ssh.connect()
.then ->
  return ssh.exec('rm -rf ./dist && mkdir ./dist && tar -zxf dist.tar.gz -C ./dist')
.then ->
  ssh.disconnect()
