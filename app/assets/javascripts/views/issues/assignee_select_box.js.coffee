class Timecard.Views.IssuesAssigneeSelectBox extends Backbone.View

  template: JST['issues/assignee_select_box']

  el: '#js-assignee-select-box'

  initialize: ->
    @current_user_id = $('.current-user').data('id')

  render: ->
    @$el.html(@template(
      members: @collection.models
      current_user_id: @current_user_id
    ))
    @
