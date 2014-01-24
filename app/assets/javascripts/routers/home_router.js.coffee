class Timecard.Routers.Home extends Backbone.Router
  routes:
    "": "index"
    "users/:user_id/projects/:project_id/issues/:state": "showUserProjectIssues"

  initialize: ->
    @projects = new Timecard.Collections.Projects()
    @issues = new Timecard.Collections.Issues()
    @workers = new Timecard.Collections.Workers()
    @workers.fetch
      success: (collection) ->
        if collection.length > 0
          @viewWorkersIndex = new Timecard.Views.WorkersIndex(collection: collection)
          @viewWorkersIndex.render().el
          user_id = $('#workers').data('user-id')
          current_user = collection.get(user_id)
          if current_user?
            workload = new Timecard.Models.Workload(current_user.get('workload'))
            Workload.start(new Date(workload.get('start_at')))

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
