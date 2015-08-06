$ = require 'jquery'
Backbone = require 'backbone'

Backbone.$ = $

module.exports = Backbone.View.extend
  el: '#content'

  initialize: ->
    @render()

  render: ->
    this.$el.html 'Hello world!'
