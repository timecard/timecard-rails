class Timecard.Views.ProjectsListItem extends Backbone.View

  template: JST['projects/list_item']

  tagName: 'li'

  className: 'projects-list__item'

  initialize: ->

  render: ->
    @$el.html(@template(project: @model))
    @
