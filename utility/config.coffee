# Base CSS URLs for template
CSS_FRAMEWORKS = 
  # Framework 7 Template
  'framework7' : 
    'base' : 'https://raw.githubusercontent.com/nolimits4web/Framework7/master/dist/css/'
    'files' : ['framework7.ios.colors.min.css', 'framework7.ios.min.css', 'framework7.material.colors.min.css', 'framework7.material.min.css']

JS_LIBS = [
  'madrobby/zepto', 
]


paths =
  scripts: ['app/**/*.coffee']
  html : ['app/**/*.html', 'app/**/*.hbs']
  styles : ['app/**/*.css','app/**/*.ttf','app/**/*.woff']
  styles_sass : ['app/**/*.sass']

exports.NON_NPM_PKG = [
  {
    name: 'zepto'
    components: ['zepto','deferred','callbacks','event']
  }
]

exports.BOWER_ROOT = './bower_components/'
exports.paths = paths
exports.JS_LIBS = JS_LIBS
exports.CSS_BASE = CSS_FRAMEWORKS.framework7
exports.CSS_FRAMEWORKS = CSS_FRAMEWORKS