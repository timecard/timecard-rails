class Timecard.Views.IssuesStatus extends Backbone.View

  template: JST['issues/status']

  el: '#status'

  initialize: (@options) ->

  render: ->
    @$el.html(@template(project_id: @options.project_id))
    @
