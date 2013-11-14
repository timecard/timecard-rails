class Timecard.Views.IssuesShow extends Backbone.View

  template: JST['issues/show']

  className: 'media issue'

  initialize: (@options) ->
    @issue = @options.issue

  render: ->
    @$el.html(@template(issue: @issue))
    @
