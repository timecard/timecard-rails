class Timecard.Views.IssuesStatusButton extends Backbone.View

  template: JST['issues/status_button']

  el: '.issue__status-button__container'

  events:
    'click .issue__status-button--open': 'open'
    'click .issue__status-button--closed': 'closed'
    'click .issue__status-button--deferred': 'deferred'

  initialize: (@options) ->

  render: ->
    @$el.html(@template())
    @

  open: (e) ->
    e.preventDefault()
    $('.issue-list__container').html('<img src="/assets/loading_mini.gif" />')
    @$('.issue__status-button').removeClass('active')
    @$('.issue__status-button--open').addClass('active')

    if @options?.project_id?
      @collection.fetch
        reset: true
        data:
          project_id: @options.project_id
          status: 'open'
    else
      @collection.fetch
        reset: true
        url: '/api/my/issues'
        data:
          status: 'open'

  closed: (e) ->
    e.preventDefault()
    $('.issue-list__container').html('<img src="/assets/loading_mini.gif" />')
    @$('.issue__status-button').removeClass('active')
    @$('.issue__status-button--closed').addClass('active')

    if @options?.project_id?
      @collection.fetch
        reset: true
        data:
          project_id: @options.project_id
          status: 'closed'
    else
      @collection.fetch
        reset: true
        url: '/api/my/issues'
        data:
          status: 'closed'

  deferred: (e) ->
    e.preventDefault()
    $('.issue-list__container').html('<img src="/assets/loading_mini.gif" />')
    @$('.issue__status-button').removeClass('active')
    @$('.issue__status-button--deferred').addClass('active')

    if @options?.project_id?
      @collection.fetch
        reset: true
        data:
          project_id: @options.project_id
          status: 'not_do_today'
    else
      @collection.fetch
        reset: true
        url: '/api/my/issues'
        data:
          status: 'not_do_today'
