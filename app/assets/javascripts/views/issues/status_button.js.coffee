class Timecard.Views.IssuesStatusButton extends Backbone.View

  template: JST['issues/status_button']

  el: '.issue__status-button__container'

  events:
    'click .issue__status-button--open': 'open'
    'click .issue__status-button--closed': 'closed'
    'click .issue__status-button--not_do_today': 'notDoToday'

  initialize: (@options) ->

  render: ->
    @$el.html(@template())
    @select(@collection.status)
    @

  open: (e) ->
    e.preventDefault()
    @collection.status = 'open'
    @loading()
    @collection.getFirstPage
      reset: true
      data:
        status: 'open'

  closed: (e) ->
    e.preventDefault()
    @collection.status = 'closed'
    @loading()
    @collection.getFirstPage
      reset: true
      data:
        status: 'closed'

  notDoToday: (e) ->
    e.preventDefault()
    @collection.status = 'not_do_today'
    @loading()
    @collection.getFirstPage
      reset: true
      data:
        status: 'not_do_today'

  select: (status) ->
    @$('.issue__status-button').removeClass('active')
    @$(".issue__status-button--#{status}").addClass('active')

  loading: ->
    new Timecard.Views.HomeLoading(el: '.issue-list')
