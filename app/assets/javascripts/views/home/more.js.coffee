class Timecard.Views.HomeMore extends Backbone.View
  template: JST['home/more']
  el: '#issues'
  events:
    'click .more': 'more'

  initialize: (@options) ->

  render: ->
    @$el.append("<button type='button' class='btn btn-default btn-block more'>More...</button>")
    @

  more: (e) ->
    @.undelegateEvents()
    $(e.target).remove()
    @collection.fetch
      data:
        user_id: @options.user_id
        project_id: @options.project_id
        status: @options.status
        page: @collection.next_page
      success: (collection) =>
        @viewIssuesList = new Timecard.Views.IssuesList(collection: collection)
        @viewIssuesList.render()
        unless collection.last_page
          @viewHomeMore = new Timecard.Views.HomeMore(collection: collection, user_id: @options.user_id, project_id: @options.project_id, status: @options.status)
          @viewHomeMore.render()
