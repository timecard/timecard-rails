class Timecard.Views.IssuesIndex extends Backbone.View

  template: JST['issues/index']

  el: '.issues-index'

  initialize: (@options) ->
    @issues = @options.issues

  render: ->
    @$el.html(@template(project_id: @options?.project_id))
    if @options?.project_id?
      @viewIssuesStatusButton = new Timecard.Views.IssuesStatusButton(project_id: @options.project_id, collection: @issues)
    else
      @viewIssuesStatusButton = new Timecard.Views.IssuesStatusButton(collection: @issues)

    @viewIssuesStatusButton.render()
    new Timecard.Views.IssuesLoading
    @issues.getFirstPage
      fetch: true
      success: (collection) =>
        @viewIssuesList = new Timecard.Views.IssuesList(collection: collection, workloads: @options.workloads)
        @viewIssuesList.render()
        @viewIssueListPagination = new Timecard.Views.IssuesListPagination(collection: collection, workloads: @options.workloads)
        @viewIssueListPagination.render()
    @
