class Timecard.Routers.Projects extends Backbone.Router
  routes:
    'projects': 'index'
    'projects/:id': 'show'
    'projects/status/:status': 'status'
    'projects/:id/issues/:status': 'issues'

  initialize: ->
    @collectionFetched = new $.Deferred
    @projects = new Timecard.Collections.Projects()
    @projects.fetch success: =>
      @collectionFetched.resolve()
    @issues = new Timecard.Collections.Issues()


  index: ->
    @collectionFetched.done =>
      @view = new Timecard.Views.ProjectsIndex(collection: @projects, router: @)
      @view.render()
      @activeStatus('open')
    false

  status: (status) ->
    @projects.fetch
      data:
        status: @parseStatus(status)
      success: (collection) =>
        @view = new Timecard.Views.ProjectsIndex(collection: collection, router: @)
        @view.render()
        @activeStatus(status)

  show: (id) ->
    @collectionFetched.done =>
      @viewProjectsShow = new Timecard.Views.ProjectsShow(model: @projects.get(id))
      @viewProjectsShow.render()
    @issues.fetch
      data:
        project_id: id
      success: (collection) =>
        @viewIssuesStatus = new Timecard.Views.IssuesStatus(project_id: id)
        @viewIssuesStatus.render()
        @viewIssuesList = new Timecard.Views.IssuesList(collection: collection)
        @viewIssuesList.render()
        @activeStatus('open')

  issues: (id, status) ->
    @collectionFetched.pipe =>
      @viewProjectsShow = new Timecard.Views.ProjectsShow(model: @projects.get(id))
      @viewProjectsShow.render()
    .done =>
      @issues.fetch
        data:
          project_id: id
          status: status
        success: (collection) =>
          @viewIssuesStatus = new Timecard.Views.IssuesStatus(project_id: id)
          @viewIssuesStatus.render()
          @viewIssuesList = new Timecard.Views.IssuesList(collection: collection)
          @viewIssuesList.render()
          @activeStatus(status)

  parseStatus: (status) ->
    return 1 if status == 'open'
    return 5 if status == 'closed'
    return 9 if status == 'archive'

  activeStatus: (status) ->
    $(".#{status}").addClass('active')
