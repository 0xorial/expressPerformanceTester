spawn = require('child_process').spawn
sequence = require 'run-sequence'
del = require 'del'
Promise = require 'bluebird'

module.exports = (gulp, $) ->

  gulp.task 'copy-server-package-json', ->
    return gulp.src('./src/tests/package.json')
      .pipe(gulp.dest('./build/server'))

  gulp.task 'clean-server', (cb) ->
    return del(['./build/server/*.*', '!./build/server/node_modules/**'])

  gulp.task 'build-server', ->
    return gulp.src('./src/tests/**/*.coffee')
      .pipe($.changed('./build/server'))
      .pipe($.plumber())
      .pipe($.coffee())
      .pipe(gulp.dest('./build/server'))

  gulp.task 'prepare-server', $.shell.task([
        'npm install --quiet'
        'npm prune --quiet'
      ], {cwd: './build/server'})

  runningServer = null

  stopServer = () ->
    return new Promise (resolve, reject) ->
      if runningServer
        runningServer.on 'exit', ->
          resolve()
        runningServer.kill()
      else
        resolve()

  gulp.task 'start-server', (cb) ->
    console.log ('starting server')
    child = spawn 'node', ['./app.js'], { cwd: './build/server' }
    child.stdout.on 'data', (data) ->
      console.log data.toString()
    child.stderr.on 'data', (data) ->
      console.log data.toString()
    runningServer = child
    child.on 'exit', ->
      runningServer = null
    cb()
    return

  gulp.task 'serve', (cb) ->
    sequence('clean-server', 'copy-server-package-json', 'build-server', 'prepare-server', 'start-server', 'watch', cb)
    return

  gulp.task 'watch', (cb) ->
    $.watch './src/tests/**/*.coffee', ->
      console.log 'change!'
      buildTask = new Promise (resolve, reject) ->
        gulp.start('build-server', resolve)

      Promise.join(buildTask, stopServer())
        .then ->
          gulp.start('start-server', ->)

    cb()
    return

  gulp.task 'package-server', (cb) ->
    gulp.src('build/server/**')
        .pipe($.tar('dist.tar'))
        .pipe($.gzip())
        .pipe(gulp.dest('./build'))

  gulp.task 'build-server-dist', (cb) ->
    sequence('clean-server', 'copy-server-package-json', 'build-server', 'prepare-server', 'package-server', cb)


