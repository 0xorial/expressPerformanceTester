gulp = module.exports = require 'gulp'
plugins = require('gulp-load-plugins')()
require('./server')(gulp, plugins)
# require('./client')(gulp, plugins)
# require('./db')(gulp, plugins)
# require('./integration')(gulp, plugins)
