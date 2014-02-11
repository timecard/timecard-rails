class Timecard.Views.IssuesAssigneeSelectBox extends Backbone.View
  
  template: JST['issues/assignee_select_box']

  el: '#js-assignee-select-box'

  initialize: ->

  render: ->
    @$el.html(@template(members: @collection.models))
    @
