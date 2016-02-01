Backbone = require "backbone"
Backbone.Marionette = require "backbone.marionette"
Template = require "./header-template.hbs"

module.exports = Backbone.Marionette.ItemView.extend
	template: Template()
