class Timecard.Views.IssuesIndex extends Backbone.View

  template: JST['issues/index']

  el: '.issues-index'

  initialize: (@options) ->
    @collection = new Timecard.Collections.Issues
    @listenTo(@collection, 'change:is_running', @render)

  render: ->
    @$el.html(@template(project_id: @options?.project_id))
    if @options?.project_id?
      @viewIssuesStatusButton = new Timecard.Views.IssuesStatusButton(project_id: @options.project_id, collection: @collection)
      @viewIssuesStatusButton.render()
    else
      @viewIssuesStatusButton = new Timecard.Views.IssuesStatusButton(collection: @collection)
      @viewIssuesStatusButton.render()

    if @options?.project_id?
      @collection.fetch
        data:
          project_id: @options.project_id
        success: (collection) =>
          @viewIssuesList = new Timecard.Views.IssuesList(collection: collection)
          @viewIssuesList.render()
    else
      @collection.fetch
        url: '/api/my/issues'
        success: (collection) ->
          @viewIssuesList = new Timecard.Views.IssuesList(collection: collection)
          @viewIssuesList.render()
    @
