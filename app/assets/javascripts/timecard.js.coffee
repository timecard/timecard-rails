window.Timecard =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    routerHome = new Timecard.Routers.Home()
    routerProjects = new Timecard.Routers.Projects()
    Backbone.history.start()

ready = ->

$(document).ready(ready)
$(document).on('page:load', ready)

$ ->
  Timecard.initialize()
