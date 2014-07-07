class Timecard.Views.IssuesStatusButton extends Backbone.View

  template: JST['issues/status_button']

  el: '.issue__status-button__container'

  events:
    'click .issue__status-button--open': 'open'
    'click .issue__status-button--closed': 'closed'
    'click .issue__status-button--deferred': 'deferred'

  initialize: ->

  render: ->
    @$el.html(@template())
    @

  open: (e) ->
    e.preventDefault()
    new Timecard.Views.IssuesLoading
    @toggle('open')
    @collection.status = 'open'
    @collection.fetch
      reset: true
      data:
        status: 'open'

  closed: (e) ->
    e.preventDefault()
    new Timecard.Views.IssuesLoading
    @toggle('closed')
    @collection.status = 'closed'
    @collection.fetch
      reset: true
      data:
        status: 'closed'

  deferred: (e) ->
    e.preventDefault()
    new Timecard.Views.IssuesLoading
    @toggle('deferred')
    @collection.status = 'not_do_today'
    @collection.fetch
      reset: true
      data:
        status: 'not_do_today'

  toggle: (status) ->
    @$('.issue__status-button').removeClass('active')
    @$(".issue__status-button--#{status}").addClass('active')
