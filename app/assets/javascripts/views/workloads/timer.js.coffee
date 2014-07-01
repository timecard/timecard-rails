class Timecard.Views.WorkloadsTimer extends Backbone.View

  template: JST['workloads/timer']

  el: '.timer'

  events:
    'click .timer-button--stop': 'stopTimer'
    'click .crowdworks-form__submit': 'addCrowdworksPassword'

  initialize: (@options) ->
    @issues = @options.issues
    @issue = @model.get('issue')

  render: ->
    @$el.html(@template(issue: @issue))
    @$('.timer__field').popover()
    Workload.start(new Date(@model.get('start_at')))
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
        Workload.stop()
        @$('.timer-button--stop').remove()
