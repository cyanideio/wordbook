gulp = require 'gulp'
browserify = require 'gulp-browserify'
concat = require 'gulp-concat'
browserSync = require 'browser-sync'

paths =
  scripts: ['app/**/*.coffee']
  html : ['app/**/*.html', 'app/**/*.hbs']
  styles : ['app/**/*.css']

gulp.task 'browserify', ->
  gulp.src 'app/main.coffee', read: false
    .pipe browserify
      debug: true
      transform: ['coffeeify', 'hbsfy']
      extension: ['.coffee']
    .pipe concat 'bundle.js'
    .pipe gulp.dest 'dist/js'
    .pipe browserSync.reload( stream: true )

gulp.task 'copyHtml', ->
  gulp.src paths.html
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

gulp.task 'browser-sync', ->
  browserSync.init
    server:
      baseDir: "./dist"

gulp.task 'default', ['browserify', 'copyHtml', 'copyCss', 'watch', 'browser-sync']

