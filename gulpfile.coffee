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

# HELPERS
# Download Function
download = (url, dest, cb) ->
  file = fs.createWriteStream(dest)
  request = https.get url, (response) ->
    response.pipe file
    file.on 'finish', ->
      file.close cb
      # close() is async, call cb after close completes.
  .on 'error', (err) ->
    # Handle errors
    fs.unlink dest
    # Delete the file async. (But we don't check the result)
    if cb then cb err.message

# Base CSS URLs for template
CSS_FRAMEWORKS = 
  # Framework 7 Template
  'framework7' : 
    'base' : 'https://raw.githubusercontent.com/nolimits4web/Framework7/master/dist/css/'
    'files' : ['framework7.ios.colors.min.css', 'framework7.ios.min.css', 'framework7.material.colors.min.css', 'framework7.material.min.css']

JS_LIBS = [
  'madrobby/zepto', 
]

CSS_BASE = CSS_FRAMEWORKS.framework7

paths =
  scripts: ['app/**/*.coffee']
  html : ['app/**/*.html', 'app/**/*.hbs']
  styles : ['app/**/*.css','app/**/*.ttf','app/**/*.woff']
  styles_sass : ['app/**/*.sass']

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
  bundle.add './bower_components/zepto/src/zepto.js'
  bundle.add './bower_components/zepto/src/deferred.js'
  bundle.add './bower_components/zepto/src/callbacks.js'
  bundle.add './bower_components/zepto/src/event.js'
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