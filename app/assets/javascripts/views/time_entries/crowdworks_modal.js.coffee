class Timecard.Views.TimeEntriesCrowdworksModal extends Backbone.View

  el: '.crowdworks-form__modal'

  events:
    'click .crowdworks-form__submit': 'addCrowdworksPassword'

  initialize: (@options) ->
    @issue = @options.issue

  addCrowdworksPassword: (e) ->
    e.preventDefault()
    @$el.modal('hide')
    password = @$('.crowdworks-form__password').val()
    remember_me = @$('.crowdworks-form__remember-me').prop('checked')
    attributes = {end_at: new Date(), password: password}
    if remember_me
      sessionStorage.setItem('crowdworks_password', password)
    current_entry = @collection.findWhere(end_at: null)
    current_entry.save attributes,
      patch: true
      wait: true
      success: (time_entry) =>
        Timecard.timer.stop()
