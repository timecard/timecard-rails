class Timecard.Routers.Home extends Backbone.Router
  routes:
    'users/:user_id/projects/:project_id/issues/:status': 'showUserProjectIssues'
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

  showUserProjectIssues: (user_id, project_id, status) ->
    @viewHomeStatus = new Timecard.Views.HomeStatus(user_id: user_id, project_id: project_id)
    @viewHomeStatus.render()
    $('#issues').html('<img src="/assets/loading_mini.gif">')
    $('.nav-pills li').removeClass('active')
    $('#project-'+project_id).addClass('active')
    $('#status a').removeClass('active')
    $("#status .#{status}").addClass('active')
    @issues.fetch
      data:
        user_id: user_id
        project_id: project_id
        status: status
      success: (collection) =>
        $('#issues').html('')
        @viewIssuesList = new Timecard.Views.IssuesList(collection: collection)
        @viewIssuesList.render()
        unless collection.last_page
          @viewHomeMore = new Timecard.Views.HomeMore(collection: collection, user_id: user_id, project_id: project_id, status: status)
          @viewHomeMore.render()
