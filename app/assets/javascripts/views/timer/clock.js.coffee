class Timecard.Views.TimerClock extends Backbone.View

  template: JST['timer/clock']

  el: '.timer__clock'

  initialize: ->

  render: ->
    @$el.html(@template(time_entry: @model))
    @
