class Timecard.Routers.Home extends Backbone.Router
  routes:
    "": "index"
    "users/:user_id/projects/:project_id/issues/:state": "showUserProjectIssues"

  initialize: ->
    @projects = new Timecard.Collections.Projects()
    @issues = new Timecard.Collections.Issues()

  index: ->
    first_page = $('ul#projects li:first a')[0].hash
    @.navigate(first_page)

  showUserProjectIssues: (user_id, project_id, state) ->
    $('.nav-pills li').removeClass('active')
    $('#project-'+project_id).addClass('active')
    @issues.fetch
      data:
        user_id: user_id
        project_id: project_id
        status: state
      success: (collection) ->
        @viewIssuesState = new Timecard.Views.IssuesState(user_id: user_id, project_id: project_id)
        @viewIssuesState.render()
        @viewIssuesIndex = new Timecard.Views.IssuesIndex(issues: collection)
        @viewIssuesIndex.render()
