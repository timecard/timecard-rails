class Timecard.Routers.Home extends Backbone.Router
  routes:
    'users/:user_id/projects/:project_id/issues/:state': 'showUserProjectIssues'
    '*path': 'index'

  initialize: ->
    @issues = new Timecard.Collections.Issues()

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
        @viewIssuesIndex = new Timecard.Views.IssuesIndex(issues: collection)
        @viewIssuesIndex.render()
        $('.nav-pills li').removeClass('active')
        $('#project-'+project_id).addClass('active')
        $('.states a').removeClass('active')
        $(".states .#{state}").addClass('active')
