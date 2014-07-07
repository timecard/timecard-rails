class Timecard.Views.IssuesListPagination extends Backbone.View

  template: JST['issues/list_pagination']

  el: '.issue-list-pagination'

  events:
    'click .issue-list-pagination__button': 'loadMoreIssues'

  initialize: (@options) ->
    @listenTo(@collection, 'sync', @refreshButton)

  render: ->
    @$el.html(@template())
    @

  loadMoreIssues: (e) ->
    e.preventDefault()
    new Timecard.Views.IssuesLoading(el: '.issue-list-pagination')
    @collection.fetch
      data:
        status: @collection.status
        page: @collection.current_page+1
      success: (collection) =>
        @viewIssuesList = new Timecard.Views.IssuesList(collection: collection, workloads: @options.workloads)
        @viewIssuesList.renderIssuesList()

  refreshButton: (collection) ->
    if collection.total_pages is collection.current_page
      @remove()
    else
      @render()
