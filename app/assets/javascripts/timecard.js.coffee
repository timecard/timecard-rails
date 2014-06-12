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
  if $('.timer').hasClass('timer--on')
    @workloads = new Timecard.Collections.Workloads
    @workloads.fetch
      url: '/api/my/workloads/latest'
      success: (collection) ->
        model = collection.findWhere(end_at: null)
        @viewWorkloadsTimer = new Timecard.Views.WorkloadsTimer(model: model)
        @viewWorkloadsTimer.render()

$(document).ready(ready)
$(document).on('page:load', ready)

$ ->
  Timecard.initialize()
