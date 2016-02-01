Backbone = require "backbone"
Backbone.Marionette = require "backbone.marionette"
Template = require "./footer-template.hbs"

module.exports = Backbone.Marionette.ItemView.extend
  template: Template()
