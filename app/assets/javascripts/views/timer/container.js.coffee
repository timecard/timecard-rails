class Timecard.Views.TimerContainer extends Backbone.View

  template: JST['timer/container']

  el: '.timer'

  initialize: ->
    @listenTo(Timecard.timer, 'notify', @renderClock)

  render: ->
    @$el.html(@template())
    @renderClock()
    Timecard.timer.start()
    # Stop Button View
    @

  renderClock: ->
    @viewTimerClock = new Timecard.Views.TimerClock(model: @model)
    @viewTimerClock.render()
    $('title').text(@model.formatted_duration())
