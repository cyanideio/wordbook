Backbone = require "backbone"
Backbone.$ = require "jquery"
Backbone.Marionette = require "backbone.marionette"
Template = require "./header-template.hbs"

module.exports = Backbone.Marionette.ItemView.extend
  template: Template()
