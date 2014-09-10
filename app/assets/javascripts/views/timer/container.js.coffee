class Timecard.Views.TimerContainer extends Backbone.View

  template: JST['timer/container']

  el: '.timer'

  initialize: (@options) ->
    @listenTo(Timecard.timer, 'notify', @renderTime)

  render: ->
    @$el.html(@template())
    @renderTime()
    @viewTimerStopButton = new Timecard.Views.TimerStopButton(model: @model, issues: @options.issues)
    @viewTimerStopButton.render()
    Timecard.timer.start()
    @

  renderTime: ->
    @viewTimerTime = new Timecard.Views.TimerTime(model: @model)
    @viewTimerTime.render()
    $('title').text(@model.formatted_duration())
