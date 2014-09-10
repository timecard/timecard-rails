class Timecard.Views.TimerTime extends Backbone.View

  template: JST['timer/time']

  el: '.timer__time'

  initialize: ->

  render: ->
    @$el.html(@template(time_entry: @model, issue: @model.get('issue')))
    @
