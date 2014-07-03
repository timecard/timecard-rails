class Timecard.Views.HomeMain extends Backbone.View

  template: JST['home/main']

  el: '.contents'

  initialize: (@options) ->

  render: ->
    @$el.html(@template())
    if @options?.project?
      @viewProjectsShow = new Timecard.Views.ProjectsShow(model: @options.project)
      @viewProjectsShow.render()
      @viewIssuesIndex = new Timecard.Views.IssuesIndex(project_id: @options.project.id, issues: @options.issues, workloads: @options.workloads)
    else
      @viewIssuesIndex = new Timecard.Views.IssuesIndex(issues: @options.issues, workloads: @options.workloads)
    @viewIssuesIndex.render()
    @
