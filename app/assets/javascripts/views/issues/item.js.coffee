class Timecard.Views.IssuesItem extends Backbone.View

  template: JST['issues/item']

  events:
    'click .js-btn-close-issue': 'closeIssue'
    'click .js-btn-reopen-issue': 'reopenIssue'
    'click .js-btn-postpone-issue': 'postponeIssue'
    'click .js-btn-do-today-issue': 'doTodayIssue'
    'mouseover': 'showActions'
    'mouseleave': 'hideActions'

  tagName: 'li'

  className: 'media issue-list__item'

  initialize: (@options) ->
    @listenTo(@model, 'change:status change:will_start_at', @remove)
    @listenTo(@model, 'change:is_running', @render)
    @viewWorkloadsTimerButton = new Timecard.Views.WorkloadsTimerButton(issue: @model, collection: @options.workloads)

  render: ->
    @$el.html(@template(
      issue: @model,
      author: @model.get('user'),
      assignee: @model.get('assignee')
      provider: @model.get('provider')
      comments: @model.get('comments')
    ))
    if @model.get('status') isnt 9
      @viewWorkloadsTimerButton.setElement(@$('.timer-button__container')).render()
    if @model.get('is_running') is true
      @$('.issue__action-buttons').removeClass('hidden')
    @

  closeIssue: (e) ->
    e.preventDefault()
    if (window.confirm("Are you sure you wish to close?"))
      @model.save({status: 9},
        patch: true
        success: (model) ->
      ).pipe =>
        if @model.previous('is_running') is true
          if @model.get('is_crowdworks') is true
            password = sessionStorage.getItem('crowdworks_password')
            if password?
              attrs = {end_at: new Date(), password: password}
              @updateWorkload(attrs)
            else
              $('.crowdworks-form__modal').modal('show')
          else
            attrs = {end_at: new Date()}
            @updateWorkload(attrs)

  reopenIssue: (e) ->
    e.preventDefault()
    @model.save {status: 1},
      patch: true
      success: (model) ->

  postponeIssue: (e) ->
    e.preventDefault()
    today = new Date()
    tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000))
    @model.save {will_start_at: tomorrow},
      patch: true
      success: (model) ->

  doTodayIssue: (e) ->
    e.preventDefault()
    @model.save {will_start_at: new Date()},
      patch: true
      success: (model) ->

  showActions: ->
    @$('.issue__action-buttons').removeClass('hidden')
    @$el.addClass('highlight')

  hideActions: ->
    if @model.get('is_running') is false
      @$('.issue__action-buttons').addClass('hidden')
    @$el.removeClass('highlight')

  remove: ->
    @$el.remove()
    @stopListening()

  updateWorkload: (attrs) ->
    workload = @options.workloads.findWhere(end_at: null)
    workload.save attrs,
      success: (model) =>
        Workload.stop()
        @model.set('is_running', false)
        $('.timer').removeClass('timer--on')
        $('.timer').addClass('timer--off')
