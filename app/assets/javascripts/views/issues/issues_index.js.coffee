class Timecard.Views.IssuesIndex extends Backbone.View

  template: JST['issues/index']

  el: "#issues"

  initialize: (@options) ->
    @$el.html("")
    @issues = @options.issues

  render: ->
    @issues.each (issue) ->
      @addIssueView(issue)
    , @
    @
  
  addIssueView: (issue) ->
    @$el.append(new Timecard.Views.IssuesShow(issue: issue).render().el)
