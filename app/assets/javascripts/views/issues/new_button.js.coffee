class Timecard.Views.IssuesNewButton extends Backbone.View

  template: JST['issues/new_button']

  el: '.issue__new-button__container'

  initialize: (@options) ->
    @project_id = @options.project_id

  render: ->
    @$el.html(@template(project_id: @project_id))
    @
