Backbone = require "backbone"
Backbone.$ = require "jquery"
Backbone.Marionette = require "backbone.marionette"

module.exports = Backbone.Marionette.LayoutView.extend
  el: "body"
  regions:
    header: "#header"
    content: "#content"
    footer: "#footer"
