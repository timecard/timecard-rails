class Timecard.Views.HomeMain extends Backbone.View

  template: JST['home/main']

  el: '.contents'

  initialize: (@options) ->
    @projects = @options.projects
    @issues = @options.issues
    @workloads = @options.workloads
    @listenTo(Timecard.mediator, 'projects:show', @renderProjectShow)

  render: ->
    @$el.html(@template())
    if @issues.project_id?
      @projects.fetch
        url: '/api/my/projects'
        success: (collection) =>
          project = collection.get(@issues.project_id)
          @renderProjectShow(project)

    @issues.getFirstPage
      fetch: true
      success: (collection) =>
        @viewIssuesIndex = new Timecard.Views.IssuesIndex(
          collection: collection
          workloads: @workloads
        )
        @viewIssuesIndex.render()
    @

  renderProjectShow: (model) ->
    @viewProjectsShow = new Timecard.Views.ProjectsShow(
      model: model
    )
    @viewProjectsShow.render()
