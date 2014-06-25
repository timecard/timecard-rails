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
    password = @$('.crowdworks-form__password').val()
    remember_me = @$('.crowdworks-form__remember-me').prop('checked')
    attrs = {end_at: new Date(), password: password}
    if remember_me
      sessionStorage.setItem('crowdworks_password', password)
    @updateWorkload(attrs)

  updateWorkload: (attrs) ->
    model = @options.workloads.findWhere(end_at: null)
    model.save attrs,
      success: (model) =>
        issue = @options.issues.findWhere(id: model.get('issue').id)
        issue.set('is_running', false)
        Workload.stop()
        $('.timer').removeClass('timer--on')
        $('.timer').addClass('timer--off')
