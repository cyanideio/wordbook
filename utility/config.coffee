JS_LIBS = ['madrobby/zepto', 'framework7']

paths =
  scripts: ['app/**/*.coffee']
  html : ['app/**/*.html', 'app/**/*.hbs']
  base_css : [
    'bower_components/Framework7/dist/css/framework7.ios.colors.min.css',
    'bower_components/Framework7/dist/css/framework7.ios.min.css'
  ]
  styles : ['app/**/*.css','app/**/*.ttf','app/**/*.woff','app/**/*.png','app/**/*.jpg']
  styles_sass : ['app/**/*.sass']

exports.NON_NPM_PKG = [
  {
    name: 'zepto'
    components: ['zepto','deferred','callbacks','event','fx']
  }
]

exports.BOWER_ROOT = './bower_components/'
exports.paths = paths
exports.JS_LIBS = JS_LIBS
