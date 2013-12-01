class Timecard.Views.IssuesState extends Backbone.View

  template: JST['issues/state']

  el: "#issue-state"

  initialize: (options) ->
    @project_id = options.project_id
    @user_id = options.user_id

  render: ->
    @$el.html(@template(user_id: @user_id, project_id: @project_id))
    @
