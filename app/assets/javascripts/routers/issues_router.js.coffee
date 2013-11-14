class Timecard.Routers.Issues extends Backbone.Router
  routes:
    "issues/:status": "index"
  
  initialize: ->
    @collection = new Timecard.Collections.Issues()

  index: (status) ->
    @collection.fetch
      data:
        status: status
      success: (collection) ->
        @viewIssuesIndex = new Timecard.Views.IssuesIndex(issues: collection)
        @viewIssuesIndex.render()
