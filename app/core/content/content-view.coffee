Backbone = require "backbone"
Backbone.Marionette = require "backbone.marionette"

Template = require "./content-template.hbs"

module.exports = Backbone.Marionette.ItemView.extend
  template: Template()
