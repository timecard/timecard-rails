class Timecard.Routers.Home extends Backbone.Router
  routes:
    'users/:user_id/projects/:project_id/issues/:state': 'showUserProjectIssues'
    '*path': 'index'

  initialize: ->
    @issues = new Timecard.Collections.Issues()
    if $('.login').hasClass('true')
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
    default_page = $('.project-nav li a').first().attr('href')
    @.navigate(default_page, trigger: true)

  showUserProjectIssues: (user_id, project_id, state) ->
    @issues.fetch
      data:
        user_id: user_id
        project_id: project_id
        status: state
      success: (collection) ->
        @viewIssuesState = new Timecard.Views.IssuesState(user_id: user_id, project_id: project_id)
        @viewIssuesState.render()
        @viewIssuesList = new Timecard.Views.IssuesList(collection: collection)
        @viewIssuesList.render()
        $('.nav-pills li').removeClass('active')
        $('#project-'+project_id).addClass('active')
        $('.states a').removeClass('active')
        $(".states .#{state}").addClass('active')
