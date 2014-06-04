class Timecard.Views.ProjectsList extends Backbone.View

  template: JST['projects/list']

  el: '.project-list__container'

  initialize: ->

  render: ->
    @$el.html(@template())
    @collection.each (project) =>
      @addProjectsListItem(project)
    @

  addProjectsListItem: (project) ->
    @viewProjectsListItem = new Timecard.Views.ProjectsListItem(model: project)
    @$('.project-list').append(@viewProjectsListItem.render().el)
