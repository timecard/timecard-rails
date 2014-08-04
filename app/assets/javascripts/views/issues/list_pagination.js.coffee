class Timecard.Views.IssuesListPagination extends Backbone.View

  template: JST['issues/list_pagination']

  el: '.issue-list-pagination'

  events:
    'click .pagination__prev': 'prevPage'
    'click .pagination__next': 'nextPage'

  initialize: (@options) ->
    @listenTo(@collection, 'reset', @unblockPage)
    @listenTo(@collection, 'reset', @render)

  render: ->
    @$el.html(@template(issues: @collection))
    @

  prevPage: (e) ->
    e.preventDefault()
    @blockPage()
    @collection.getPreviousPage
      reset: true
      data:
        status: @collection.status

  nextPage: (e) ->
    e.preventDefault()
    @blockPage()
    @collection.getNextPage
      reset: true
      data:
        status: @collection.status

  blockPage: ->
    $('body').block(message: null)
    @$('.clearfix').append("<img src='/assets/loading_mini.gif' />")

  unblockPage: ->
    $('body').unblock()
