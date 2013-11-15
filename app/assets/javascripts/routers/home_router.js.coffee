class Timecard.Routers.Home extends Backbone.Router
  routes:
    "users/:user_id/projects/:id": "showUserProjects"
    "users/:user_id/projects/:id/issues/:state": "showUserProjectIssues"

  initialize: ->
    @projects = new Timecard.Collections.Projects()
    @issues = new Timecard.Collections.Issues()

  showUserProjects: (user_id, id) ->
    @issueStateNav(user_id, id)
    @issues.fetch
      data:
        user_id: user_id
        project_id: id
      success: (collection) ->
        @viewIssuesIndex = new Timecard.Views.IssuesIndex(issues: collection)
        @viewIssuesIndex.render()

  showUserProjectIssues: (user_id, id, state) ->
    @issueStateNav(user_id, id)
    @issues.fetch
      data:
        user_id: user_id
        project_id: id
        status: state
      success: (collection) ->
        @viewIssuesIndex = new Timecard.Views.IssuesIndex(issues: collection)
        @viewIssuesIndex.render()

  issueStateNav: (user_id, project_id) ->
    @projects.fetch
      success: (collection) ->
        @project = collection.get(project_id)
        @viewHomeIssueState = new Timecard.Views.HomeIssueState(user_id: user_id, project: @project)
        @viewHomeIssueState.render()
