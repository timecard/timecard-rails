class Timecard.Views.ProjectsListItem extends Backbone.View

  template: JST['projects/list_item']

  events:
    'click .project__name--link': 'show'

  tagName: 'li'

  className: 'project-list__item'

  initialize: (@options) ->

  render: ->
    @$el.html(@template(project: @model))
    @

  show: (e) ->
    e.preventDefault()
    $('.project-list__item').removeClass('project-list__item--current')
    @$el.addClass('project-list__item--current')
    @viewProjectsShow = new Timecard.Views.ProjectsShow(model: @model)
    @viewProjectsShow.render()
    @viewIssuesIndex = new Timecard.Views.IssuesIndex(project_id: @model.id, issues: @options.issues, workloads: @options.workloads)
    @viewIssuesIndex.render()
    @options.router.navigate('/my/projects/'+@model.id, trigger: false)
