class Timecard.Views.ProjectsListItem extends Backbone.View

  template: JST['projects/list_item']

  events:
    'click .project__name--link': 'show'

  tagName: 'li'

  className: 'project-list__item'

  initialize: ->

  render: ->
    @$el.html(@template(project: @model))
    @

  show: (e) ->
    e.preventDefault()
    @viewIssuesIndex = new Timecard.Views.IssuesIndex(project: @model)
    @viewIssuesIndex.render()
