class Timecard.Views.TimeEntriesButtons extends Backbone.View

  el: '.time-entries__buttons'

  events:
    'click .time-entries__start-button': 'start'
    'click .time-entries__stop-button': 'stop'

  initialize: (@options) ->
    @issue = @options.issue

  start: (e) ->
    e.preventDefault()
    @collection.create { start_at: new Date() },
      url: '/issues/'+@issue.id+'/workloads'
      success: (time_entry) ->

  stop: (e) ->
    e.preventDefault()
    if @issue.isCrowdworks is true
      password = sessionStorage.getItem('crowdworks_password')
      if password?
        attributes = {end_at: new Date(), password: password}
        @update(attributes)
      else
        $('.crowdworks-form__modal').modal('show')
    else
      attributes = {end_at: new Date()}
      @update(attributes)

  update: (attributes) ->
    @current_entry = @collection.findWhere(end_at: null)
    @current_entry.save attributes,
      patch: true
      wait: true
      success: (time_entry) ->
        Timecard.timer.stop()
