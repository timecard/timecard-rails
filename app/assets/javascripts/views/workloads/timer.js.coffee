class Timecard.Views.WorkloadsTimer extends Backbone.View

  template: JST['workloads/timer']

  el: '.timer'

  events:
    'click .timer-button--stop': 'stopTimer'

  initialize: (@options) ->
    @issues = @options.issues

  render: ->
    @$el.html(@template(workload: @model))
    Workload.start(new Date(@model.get('start_at')))
    @

  stopTimer: (e) ->
    e.preventDefault()
    @model.save {end_at: new Date()},
      success: (model) =>
        issue = @issues.get(model.get('issue').id)
        if issue?
          issue.set('is_running', false)
        Workload.stop()
        @$('.timer-button--stop').remove()
