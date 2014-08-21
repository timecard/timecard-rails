class Timecard.Views.IssuesIndex extends Backbone.View

  template: JST['issues/index']

  el: '.issues-index'

  initialize: (@options) ->
    @workloads = @options.workloads
    @listenTo(@collection, 'reset', @render)

  render: ->
    @$el.html(@template())
    if @collection.project_id?
      @viewIssuesNewButton = new Timecard.Views.IssuesNewButton(project_id: @collection.project_id)
      @viewIssuesNewButton.render()
    @viewIssuesStatusButton = new Timecard.Views.IssuesStatusButton(collection: @collection)
    @viewIssuesStatusButton.render()
    @viewIssuesList = new Timecard.Views.IssuesList(
      collection: @collection
      workloads: @workloads
    )
    @viewIssuesList.render()
    @viewIssueListPagination = new Timecard.Views.IssuesListPagination(
      collection: @collection
    )
    @viewIssueListPagination.render()
    @
