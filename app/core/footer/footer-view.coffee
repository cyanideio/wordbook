Backbone = require "backbone"
Backbone.$ = require "jquery"
Backbone.Marionette = require "backbone.marionette"
Template = require "./footer-template.hbs"

module.exports = Backbone.Marionette.ItemView.extend
  template: Template()
