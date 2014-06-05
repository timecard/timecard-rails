class Timecard.Views.WorkloadsTimer extends Backbone.View

  template: JST['workloads/timer']

  el: '.timer'

  initialize: ->

  render: ->
    @$el.html(@template(workload: @model))
    @
