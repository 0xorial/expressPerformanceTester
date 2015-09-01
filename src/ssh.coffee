Promise = require 'bluebird'

class Ssh
  constructor: (@remote) ->
    pkPath = require('fs').readFileSync('./config/server-pk-path', 'utf-8')
    @privateKey = require('fs').readFileSync(pkPath)

  connect: ->
    return new Promise (resolve, reject) =>
      Client = require('ssh2').Client
      @conn = new Client()
      @conn.on 'error', (err) =>
        @_onRemoteConnectionError(err)
        reject()

      @conn.on 'ready', -> resolve()

      @conn.connect
        host: @remote
        port: 22
        username: 'root'
        privateKey: @privateKey

    .then =>
      @isConnected = true

  disconnect: ->
    @conn.end()

  _onRemoteStdout: (data) ->
    console.log 'STDOUT: ' + data
  _onRemoteStderr: (data) ->
    console.log 'STDERR: ' + data

  _onRemoteConnectionError: (err)->
    console.log 'ERROR:'
    console.log err

  exec: (command) ->
    if !@isConnected
      throw new Error('not connected!')

    return new Promise (resolve, reject) =>
      @conn.exec command, (err, stream) =>
        if err
          reject(err)
          return

        @stream = stream

        stream.on('close', (code, signal) ->
          @stream = null
          resolve({code: code, signal: signal})
        ).on('data', @_onRemoteStdout)
        .stderr.on 'data', @_onRemoteStderr
        return

  interrupt: ->
    if @stream
      @stream.write('\x03')



module.exports = Ssh