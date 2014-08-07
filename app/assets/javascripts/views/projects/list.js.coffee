class Timecard.Views.ProjectsList extends Backbone.View

  template: JST['projects/list']

  el: '.projects-list__container'

  events:
    'click .project-all--link': 'show'

  initialize: (@options) ->
    @issues = @options.issues
    @workloads = @options.workloads
    @router = @options.router

  render: ->
    @$el.html(@template())
    @collection.each (project) =>
      @addProjectsListItem(project)
    @

  addProjectsListItem: (project) ->
    @viewProjectsListItem = new Timecard.Views.ProjectsListItem(
      model: project
      issues: @issues
      router: @router
    )
    @$('.project-list').append(@viewProjectsListItem.render().el)

  show: (e) ->
    e.preventDefault()
    $('.project-list__item').removeClass('project-list__item--current')
    $(e.target).closest('li').addClass('project-list__item--current')
    $('.projects-show').empty()
    @issues.url = '/api/my/issues'
    @issues.status = 'open'
    new Timecard.Views.HomeLoading(el: '.issues-index')
    @issues.getFirstPage
      reset: true
    @router.navigate('/my/projects', trigger: false)
