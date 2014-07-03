class Timecard.Views.ProjectsShow extends Backbone.View

  template: JST['projects/show']

  el: '.projects-show'

  initialize: ->

  render: ->
    @$el.html(@template(project: @model))
    @
