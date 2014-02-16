class Timecard.Routers.Projects extends Backbone.Router
  routes:
    'projects': 'index'
    'projects/status/:status': 'status'

  initialize: ->
    @projects = new Timecard.Collections.Projects()

  index: ->
    @projects.fetch
      success: (collection) =>
        @view = new Timecard.Views.ProjectsIndex(collection: collection, router: @)
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
    false

  parseStatus: (status) ->
    return 1 if status == 'open'
    return 5 if status == 'closed'
    return 9 if status == 'archive'

  activeStatus: (status) ->
    $(".#{status}").addClass('active')
