Backbone = require "backbone"
Backbone.$ = $
Backbone.Marionette = require "backbone.marionette"
_ = require "underscore"
AppLayout = require "./core/app-layout"
config = require "./core/utils/config"
data = require "./core/utils/data"
Swiper = require "swiper"

CardCollection = require "./core/collections/card"
CardCollectionView = require "./core/views/CardCollectionView"
MenuItemView = require "./core/views/MenuItemView"

$(document).ready ->
  swiper = new Swiper config.MAIN_SWIPER_WRAPPER, config.MAIN_SWIPER_CONFIG

app = new Backbone.Marionette.Application()
app.addInitializer (options) ->
  x = new CardCollection _.map data.split(' '), (w)->
    word: w
  cardCollectionView = new CardCollectionView
    collection: x
  menuItemView = new MenuItemView()
  app.root = new AppLayout()

  app.root.getRegion('center').show cardCollectionView
  app.root.getRegion('left').show menuItemView

$(document).ready ->
  app.start()
