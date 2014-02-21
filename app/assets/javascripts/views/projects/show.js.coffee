class Timecard.Views.ProjectsShow extends Backbone.View

  template: JST['projects/show']

  el: '#page'

  initialize: ->

  render: ->
    @$el.html(@template(project: @model))
    @
