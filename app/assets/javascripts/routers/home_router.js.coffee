class Timecard.Routers.Home extends Backbone.Router
  routes:
    "": "index"
  
  initialize: ->
    @collection = new Timecard.Collections.Issues()

  index: (status) ->
    @collection.fetch
      data:
        status: status
      success: (collection) ->
        @viewIssuesIndex = new Timecard.Views.IssuesIndex(issues: collection)
        @viewIssuesIndex.render()
