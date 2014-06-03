class Timecard.Views.IssuesIndex extends Backbone.View

  template: JST['issues/index']

  el: '.contents'

  initialize: (@options) ->
    @project = @options.project
    @issues = new Timecard.Collections.Issues

  render: ->
    @$el.html(@template(project: @project))
    @issues.fetch
      data:
        project_id: @project.id
      success: (collection) =>
        @viewIssuesStatusButton = new Timecard.Views.IssuesStatusButton(project: @project, collection: collection)
        @viewIssuesStatusButton.render()
        @viewIssuesList = new Timecard.Views.IssuesList(collection: collection)
        @viewIssuesList.render()
    @
