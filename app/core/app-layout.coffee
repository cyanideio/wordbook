Backbone = require "backbone"
Backbone.Marionette = require "backbone.marionette"

class AppLayout extends Backbone.Marionette.LayoutView
  el: "body"
  regions:
    left: ".left"
    center: ".center"
    right: ".right"

module.exports = AppLayout