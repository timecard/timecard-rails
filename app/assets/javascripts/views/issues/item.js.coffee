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

  initialize: ->
    @listenTo(@model, 'change:status', @remove)
    @listenTo(@model, 'change:will_start_at', @remove)
    @workloads = new Timecard.Collections.Workloads
    @viewWorkloadsTimerButton = new Timecard.Views.WorkloadsTimerButton(issue: @model, collection: @workloads)

  render: ->
    @$el.html(@template(
      issue: @model,
      author: @model.get('user'),
      assignee: @model.get('assignee')
      provider: @model.get('provider')
    ))
    if @model.get('status') isnt 9
      @viewWorkloadsTimerButton.setElement(@$('.timer-button__container')).render()
    if @model.get('is_running') is true
      @$('.issue-list__item__button-group').removeClass('hidden')
    @

  closeIssue: (e) ->
    e.preventDefault()
    if (window.confirm("Are you sure you wish to close?"))
      @model.save {status: 9},
        url: @model.urlRoot+'/'+@model.id+'/close'
        patch: true
        success: (model) ->

  reopenIssue: (e) ->
    e.preventDefault()
    @model.save {status: 1},
      url: @model.urlRoot+'/'+@model.id+'/reopen'
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
    @$('.issue-list__item__button-group').removeClass('hidden')
    @$el.addClass('highlight')

  hideActions: ->
    if @model.get('is_running') is false
      @$('.issue-list__item__button-group').addClass('hidden')
    @$el.removeClass('highlight')

  remove: ->
    @$el.remove()
