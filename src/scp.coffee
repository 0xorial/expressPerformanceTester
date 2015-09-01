Promise = require 'bluebird'

module.exports.copy = (remote, file, targetPath) ->
  client = require 'scp2'
  scp = Promise.promisify(client.scp, client)
  pkPath = require('fs').readFileSync('./config/server-pk-path', 'utf-8')
  return scp(file, {
      host: remote
      username: 'root'
      privateKey: require('fs').readFileSync(pkPath)
      path: targetPath
    })
