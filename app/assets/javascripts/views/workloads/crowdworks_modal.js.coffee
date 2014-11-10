class Timecard.Views.WorkloadsCrowdworksModal extends Backbone.View

  template: JST['workloads/crowdworks_modal']

  el: '.crowdworks-modal__container'

  events:
    'click .crowdworks-form__submit': 'addCrowdworksPassword'

  initialize: (@options) ->

  render: ->
    @$el.html(@template())
    @

  addCrowdworksPassword: ->
    $('.timer-button--stop').text('Sending ...').attr('disabled', 'disabled')
    password = @$('.crowdworks-form__password').val()
    remember_me = @$('.crowdworks-form__remember-me').prop('checked')
    attrs = {end_at: new Date(), password: password}
    if remember_me
      sessionStorage.setItem('crowdworks_password', password)
    model = @options.workloads.findWhere(end_at: null)
    model.save attrs,
      success: (workload) =>
        issue = @options.issues.findWhere(id: model.get('issue').id)
        issue.set('is_running', false)
        Timecard.timer.stop()
      error: (workload, response, options) =>
        json = $.parseJSON(response.responseText)
        workload = new Timecard.Models.Workload(
          $.parseJSON(json.workload)
        )
        if workload.isStopped
          issue = @options.issues.findWhere(id: model.get('issue').id)
          issue.set('is_running', false)
          Timecard.timer.stop()
