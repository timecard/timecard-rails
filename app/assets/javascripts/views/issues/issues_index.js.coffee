class Timecard.Views.IssuesIndex extends Backbone.View

  template: JST['issues/index']

  el: "#issues"

  initialize: (@options) ->
    @$el.html("")
    @issues = @options.issues

  render: ->
    if @issues.length is 0
      @$el.append("<div class='media'><p>You don't have assigned issue.</p></div>")
    else
      @issues.each (issue) ->
        @addIssueView(issue)
      , @
    @
  
  addIssueView: (issue) ->
    @$el.append(new Timecard.Views.IssuesShow(issue: issue).render().el)
