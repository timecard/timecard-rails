class Timecard.Views.IssuesIndex extends Backbone.View

  template: JST['issues/index']

  el: '.issues-index'

  initialize: (@options) ->
    @issues = @options.issues
    if @options?.project_id?
      @issues.url = '/api/my/projects/'+@options.project_id+'/issues'
    else
      @issues.url = '/api/my/issues'

  render: ->
    @$el.html(@template(project_id: @options?.project_id))
    @viewIssuesStatusButton = new Timecard.Views.IssuesStatusButton(collection: @issues)
    @viewIssuesStatusButton.render()
    new Timecard.Views.IssuesLoading
    @issues.fetch
      success: (collection) =>
        @viewIssuesList = new Timecard.Views.IssuesList(collection: collection, workloads: @options.workloads)
        @viewIssuesList.render()
    @
