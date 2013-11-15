class Timecard.Views.ProjectsShow extends Backbone.View

  template: JST['projects/show']

  initialize: (@options) ->
    @project = @options.project

  render: ->
    @$el.html(@template(project: @project.attributes))
    @
