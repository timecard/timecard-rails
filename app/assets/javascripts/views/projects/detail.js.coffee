class Timecard.Views.ProjectsDetail extends Backbone.View

  template: JST['projects/detail']

  el: '.project-detail'

  initialize: ->

  render: ->
    @$el.html(@template(project: @model))
    @
