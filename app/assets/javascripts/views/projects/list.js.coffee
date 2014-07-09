class Timecard.Views.ProjectsList extends Backbone.View

  template: JST['projects/list']

  el: '.projects-list__container'

  events:
    'click .project-all--link': 'show'

  initialize: (@options) ->

  render: ->
    @$el.html(@template())
    @collection.each (project) =>
      @addProjectsListItem(project)
    @

  addProjectsListItem: (project) ->
    @viewProjectsListItem = new Timecard.Views.ProjectsListItem(model: project, issues: @options.issues, workloads: @options.workloads, router: @options.router)
    @$('.project-list').append(@viewProjectsListItem.render().el)

  show: (e) ->
    e.preventDefault()
    $('.project-list__item').removeClass('project-list__item--current')
    $(e.target).closest('li').addClass('project-list__item--current')
    $('.projects-show').empty()
    @viewIssuesIndex = new Timecard.Views.IssuesIndex(issues: @options.issues, workloads: @options.workloads)
    @viewIssuesIndex.render()
    @options.router.navigate('/my/projects', trigger: false)
