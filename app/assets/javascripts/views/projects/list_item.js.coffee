class Timecard.Views.ProjectsListItem extends Backbone.View

  template: JST['projects/list_item']

  events:
    'click .projects__name--link': 'show'

  tagName: 'li'

  className: 'projects-list__item'

  initialize: ->

  render: ->
    @$el.html(@template(project: @model))
    @

  show: (e) ->
    e.preventDefault()
    @viewProjectsShow = new Timecard.Views.ProjectsShow(model: @model)
    @viewProjectsShow.render()
