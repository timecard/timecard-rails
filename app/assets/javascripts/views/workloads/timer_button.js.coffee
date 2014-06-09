class Timecard.Views.WorkloadsTimerButton extends Backbone.View

  template: JST['workloads/timer_button']

  el: '.timer-button__container'

  events:
    'click .timer-button--start': 'startTimer'
    'click .timer-button--stop': 'stopTimer'
    'click .crowdworks-form__submit': 'addCrowdworksPassword'

  initialize: (@options) ->
    @issue = @options.issue
    @issues = @issue.collection
    @listenTo(@issues, 'change:is_running', @render)

  render: ->
    @$el.html(@template(issue: @issue))
    @

  startTimer: (e) ->
    e.preventDefault()
    if Workload.timerId?
      Workload.stop()
    @collection.create {start_at: new Date()},
      url: '/issues/'+@issue.id+'/workloads'
      success: (model) =>
        @issue.set('is_running', true)
        @viewWorkloadsTimer = new Timecard.Views.WorkloadsTimer(model: model)
        @viewWorkloadsTimer.render()
        $('.issue-list__container').html('<img src="/assets/loading_mini.gif" />')
        $('.timer').removeClass('timer--off')
        $('.timer').addClass('timer--on')

  stopTimer: (e) ->
    e.preventDefault()
    if @issue.get('is_crowdworks') is true
      @$('.crowdworks-form__modal').modal('show')
    else
      attrs = {end_at: new Date()}
      @updateWorkload(attrs)

  addCrowdworksPassword: ->
    password = $('.crowdworks-form__password').val()
    attrs = {end_at: new Date(), password: password}
    @updateWorkload(attrs)

  updateWorkload: (attrs) ->
    @collection.fetch
      url: '/api/my/workloads/latest'
      success: (collection) =>
        model = collection.findWhere(end_at: null)
        model.save attrs,
          success: (model) =>
            @issue.set('is_running', false)
            Workload.stop()
            $('.issue-list__container').html('<img src="/assets/loading_mini.gif" />')
            $('.timer').removeClass('timer--on')
            $('.timer').addClass('timer--off')
