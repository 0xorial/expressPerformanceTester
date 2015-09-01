Promise = require 'bluebird'

exports.build = ->
  return new Promise (resolve, reject) ->
    gulp = require('../gulpfile')

    gulp.on 'task_start', (e) ->
      console.log e
    gulp.on 'task_stop', (e) ->
      console.log e
    gulp.on 'task_err', (e) ->
      console.log e
    gulp.on 'err', (e) ->
      console.log e

    gulp.start('build-server-dist', (err) ->
      if err
        reject(err)

      console.log(arguments)
      resolve())
