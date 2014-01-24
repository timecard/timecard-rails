ready = ->

window.Timecard =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    routerHome = new Timecard.Routers.Home()
    Backbone.history.start()

$(document).ready(ready)
$(document).on('page:change', ready)

$ ->
  Timecard.initialize()
