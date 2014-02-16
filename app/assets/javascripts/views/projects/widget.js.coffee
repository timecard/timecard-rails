class Timecard.Views.ProjectsWidget extends Backbone.View

  template: JST['projects/widget']

  el: '#projects-list'

  initialize: ->

  render: ->
    @$el.append(@template(project: @model))
    @
