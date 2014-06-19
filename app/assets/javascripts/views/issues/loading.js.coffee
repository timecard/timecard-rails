class Timecard.Views.IssuesLoading extends Backbone.View

  template: JST['issues/loading']

  el: '.issue-list__container'

  initialize: ->
    @render()

  render: ->
    @$el.html(@template())
    @
