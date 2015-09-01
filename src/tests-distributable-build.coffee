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
    gulp.on 'task_recursion', (e) ->
      console.log e

    process.nextTick ->

      gulp.start.apply(gulp, ['build-server-dist'])

  .delay(10000)
