class Timecard.Views.ProjectsListItem extends Backbone.View

  template: JST['projects/list_item']

  events:
    'click .project__name--link': 'show'

  tagName: 'li'

  className: 'project-list__item'

  initialize: (@options) ->
    @issues = @options.issues
    @router = @options.router

  render: ->
    @$el.html(@template(project: @model))
    @

  show: (e) ->
    e.preventDefault()
    $('.project-list__item').removeClass('project-list__item--current')
    @$el.addClass('project-list__item--current')
    Timecard.mediator.trigger('projects:show', @model)
    @issues.project_id = @model.id
    @issues.url = '/api/my/projects/'+@model.id+'/issues'
    @issues.status = 'open'
    new Timecard.Views.HomeLoading(el: '.issues-index')
    @issues.getFirstPage
      reset: true
    @router.navigate('/my/projects/'+@model.id, trigger: false)
