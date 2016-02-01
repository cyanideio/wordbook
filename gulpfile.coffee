gulp = require 'gulp'
sass = require 'gulp-sass'
bower = require 'bower'
browserSync = require 'browser-sync'

source = require 'vinyl-source-stream'
browserify = require 'browserify'
coffeeify = require 'coffeeify'
hbsfy = require('hbsfy').configure
  extensions :['hbs']

https = require 'https'
fs = require 'fs'
util = require 'util'
exec = require('child_process').exec

download = require './utility/download'
paths = require('./utility/config').paths
JS_LIBS = require('./utility/config').JS_LIBS
CSS_FRAMEWORKS = require('./utility/config').CSS_FRAMEWORKS
BOWER_ROOT = require('./utility/config').BOWER_ROOT
NON_NPM_PKG = require('./utility/config').NON_NPM_PKG

gulp.task 'fetchStatic', ->
  for file in CSS_BASE.files
    console.log "Download #{file} starts"
    download "#{CSS_BASE.base}#{file}", "app/css/#{file}", ->
      console.log "#Synced"

  bower.commands
    .install JS_LIBS, 
      save: true
    .on 'end', (installed)->
      console.log installed

gulp.task 'browserify', ->
  bundle = browserify
    extensions: ['.coffee']
  bundle.transform coffeeify,
    bare: false
    header: true
  bundle.transform hbsfy
  for pkg in NON_NPM_PKG
    pkgname = pkg.name
    for comp in pkg.components
      bundle.add "#{BOWER_ROOT}#{pkgname}/src/#{comp}.js"
  bundle.add './app/main.coffee'
  bundle.bundle()
  .pipe source 'bundle.js'
  .pipe gulp.dest 'dist/js'
  .pipe browserSync.reload( stream: true )

gulp.task 'copyHtml', ->
  gulp.src paths.html
    .pipe gulp.dest 'dist'
    .pipe browserSync.reload( stream: true )

gulp.task 'sass', ->
  gulp.src paths.styles_sass
    .pipe sass( outputStyle: 'compressed' )
    .on 'error', sass.logError
    .pipe gulp.dest 'dist'
    .pipe browserSync.reload( stream: true )

gulp.task 'copyCss', ->
  gulp.src paths.styles
    .pipe gulp.dest 'dist'
    .pipe browserSync.reload( stream: true )

gulp.task 'watch', ->
  gulp.watch paths.scripts, ['browserify']
  gulp.watch paths.html, ['copyHtml', 'browserify']
  gulp.watch paths.styles, ['copyCss']
  gulp.watch paths.styles_sass, ['sass']

gulp.task 'browser-sync', ->
  browserSync.init
    server:
      baseDir: "./dist"

gulp.task 'default', ['browserify', 'copyHtml', 'sass', 'copyCss', 'watch', 'browser-sync']