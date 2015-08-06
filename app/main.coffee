$ = require('jquery')(window)

underscore = require 'underscore'
Backbone = require('backbone')

Backbone.$ = $

AppView = require './app-view.coffee'

appView = new AppView()
