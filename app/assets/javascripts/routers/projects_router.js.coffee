class Timecard.Routers.Projects extends Backbone.Router
  routes:
    'projects': 'index'
    'projects/:id': 'show'
    'projects/status/:status': 'status'
    'projects/:id/issues/:status': 'issues'

  initialize: ->
    @projects = new Timecard.Collections.Projects()
    @issues = new Timecard.Collections.Issues()

  index: ->
    status = 'open'
    @projects.fetch
      success: (collection) =>
        @view = new Timecard.Views.ProjectsIndex(collection: collection, router: @)
        @view.render()
        @activeStatus(status)
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
    @project = new Timecard.Models.Project({id: id})
    @project.fetch
      success: (model) ->
        @viewProjectsShow = new Timecard.Views.ProjectsShow(model: model)
        @viewProjectsShow.render()

  issues: (id, status) ->
    @project = new Timecard.Models.Project({id: id})
    @project.fetch
      success: (model) ->
        @viewProjectsShow = new Timecard.Views.ProjectsShow(model: model, status: status)
        @viewProjectsShow.render()

  parseStatus: (status) ->
    return 1 if status == 'open'
    return 5 if status == 'closed'
    return 9 if status == 'archive'

  activeStatus: (status) ->
    $(".#{status}").addClass('active')
