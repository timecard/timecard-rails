class Timecard.Views.ProjectsShow extends Backbone.View

  template: JST['projects/show']

  el: '#page'

  initialize: (@options) ->
    @model.on('change:status', @reloadActions, @)
    @issues = new Timecard.Collections.Issues
    @status = if @options.status then @options.status else 'open'

  render: ->
    @$el.html(@template(project: @model))
    @viewProjectsAction = new Timecard.Views.ProjectsAction(model: @model)
    @viewProjectsAction.render()
    @issues.fetch
      data:
        project_id: @model.get('id')
        status: @status
      success: (collection) =>
        @viewIssuesStatus = new Timecard.Views.IssuesStatus(project_id: @model.get('id'))
        @viewIssuesStatus.render()
        @viewIssuesList = new Timecard.Views.IssuesList(collection: collection)
        @viewIssuesList.render()
        $(".#{@status}").addClass('active')
    @

  reloadActions: ->
    @viewProjectsAction = new Timecard.Views.ProjectsAction(model: @model)
    @viewProjectsAction.render()
