class Timecard.Views.HomeLoading extends Backbone.View

  template: JST['home/loading']

  initialize: ->
    @render()

  render: ->
    @$el.html(@template())
    @
