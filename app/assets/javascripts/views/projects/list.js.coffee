class Timecard.Views.ProjectsList extends Backbone.View

  template: JST['projects/list']

  el: '.project-list__container'

  initialize: (@options) ->

  render: ->
    @$el.html(@template())
    @collection.each (project) =>
      @addProjectsListItem(project)
    @

  addProjectsListItem: (project) ->
    @viewProjectsListItem = new Timecard.Views.ProjectsListItem(model: project, issues: @options.issues, workloads: @options.workloads)
    @$('.project-list').append(@viewProjectsListItem.render().el)
