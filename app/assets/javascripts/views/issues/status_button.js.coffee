class Timecard.Views.IssuesStatusButton extends Backbone.View

  template: JST['issues/status_button']

  el: '.issue__status-button__container'

  events:
    'click .issue__status-button--open': 'open'
    'click .issue__status-button--closed': 'closed'
    'click .issue__status-button--deferred': 'deferred'

  initialize: (@options) ->
    @project = @options.project

  render: ->
    @$el.html(@template())
    @

  open: (e) ->
    e.preventDefault()
    $('.issue-list__container').html('<img src="/assets/loading_mini.gif" />')
    @collection.fetch
      reset: true
      data:
        project_id: @project.id
        status: 'open'

  closed: (e) ->
    e.preventDefault()
    $('.issue-list__container').html('<img src="/assets/loading_mini.gif" />')
    @collection.fetch
      reset: true
      data:
        project_id: @project.id
        status: 'closed'

  deferred: (e) ->
    e.preventDefault()
    $('.issue-list__container').html('<img src="/assets/loading_mini.gif" />')
    @collection.fetch
      reset: true
      data:
        project_id: @project.id
        status: 'not_do_today'
