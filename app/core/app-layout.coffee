Backbone = require "backbone"
Backbone.Marionette = require "backbone.marionette"

module.exports = Backbone.Marionette.LayoutView.extend
  el: "body"
  regions:
    header: "#header"
    content: "#content"
    footer: "#footer"
