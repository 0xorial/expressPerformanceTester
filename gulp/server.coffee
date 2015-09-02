spawn = require('child_process').spawn
sequence = require 'run-sequence'
del = require 'del'
Promise = require 'bluebird'

module.exports = (gulp, $) ->

  gulp.task 'copy-server-package-json', ->
    return gulp.src('./src/tests/package.json')
      .pipe(gulp.dest('./build/server'))

  gulp.task 'clean-server', (cb) ->
    return del(['./build/server/**/*', './build/server/dist.tar.gz', '!./build/server/node_modules/**'])

  gulp.task 'copy-server-files', ->
    return gulp.src('./src/tests/**/*.html')
      .pipe($.changed('./build/server'))
      .pipe(gulp.dest('./build/server'))

  gulp.task 'build-server', ['copy-server-files'], ->
    return gulp.src('./src/tests/**/*.coffee')
      .pipe($.changed('./build/server'))
      .pipe($.plumber())
      .pipe($.coffee())
      .pipe(gulp.dest('./build/server'))

  gulp.task 'build-server-full', (cb) ->
    sequence('clean-server', 'copy-server-package-json', 'build-server', 'prepare-server', 'package-server', cb)

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

  gulp.task 'package-server', (cb) ->
    gulp.src('build/server/**')
        .pipe($.tar('dist.tar'))
        .pipe($.gzip())
        .pipe(gulp.dest('./build'))

  gulp.task 'build-server-dist', (cb) ->
    sequence('clean-server', 'copy-server-package-json', 'build-server', 'prepare-server', 'package-server', cb)


