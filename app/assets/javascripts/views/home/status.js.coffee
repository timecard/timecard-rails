class Timecard.Views.HomeStatus extends Backbone.View

  template: JST['home/status']

  el: "#status"

  initialize: (@options) ->

  render: ->
    @$el.html(@template(
      user_id: @options.user_id, project_id: @options.project_id
    ))
    @
