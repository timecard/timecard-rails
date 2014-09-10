class Timecard.Views.TimerStopButton extends Backbone.View

  template: JST['timer/stop_button']

  el: '.timer__stop-button'

  events:
    'click .timer__stop-button__link': 'stopTimer'

  initialize: (@options) ->
    @issues = @options.issues
    @issue = @model.get('issue')
    @listenTo(@model, 'change:end_at', @destroy)

  render: ->
    @$el.html(@template(issue: @issue))
    @

  stopTimer: (e) ->
    e.preventDefault()
    issue = @model.get('issue')
    if issue.get('is_crowdworks') is true
      $('.crowdworks-form__modal').modal('show')
    else
      attrs = {end_at: new Date()}
      @updateWorkload(attrs)

  addCrowdworksPassword: ->
    password = $('.crowdworks-form__password').val()
    attrs = {end_at: new Date(), password: password}
    @updateWorkload(attrs)

  updateWorkload: (attrs) ->
    @model.save attrs,
      success: (model) =>
        issue = @issues.get(model.get('issue').id)
        if issue?
          issue.set('is_running', false)
        Timecard.timer.stop()

  destroy: ->
    @remove()
