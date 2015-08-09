Backbone = require 'backbone'
Backbone.$ = require 'jquery'

module.exports = Backbone.View.extend
  el: '#content'

  initialize: ->
    @render()

  render: ->
    this.$el.html 'Hello world!'
