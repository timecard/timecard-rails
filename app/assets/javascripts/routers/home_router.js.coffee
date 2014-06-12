class Timecard.Routers.Home extends Backbone.Router
  routes:
    'my/projects/:id': 'show'
    '*path': 'index'

  initialize: ->
    @workloads = new Timecard.Collections.Workloads

  index: ->
    @viewHomeSidebar = new Timecard.Views.HomeSidebar(router: @)
    @viewHomeSidebar.render()
    @workloads.fetch
      url: '/api/my/workloads/latest'
      success: (workloads) =>
        @viewHomeMain = new Timecard.Views.HomeMain(workloads: workloads)
        @viewHomeMain.render()
        @renderGlobalTimer(workloads)

  show: (id) ->
    @viewHomeSidebar = new Timecard.Views.HomeSidebar(project_id: id, router: @)
    @viewHomeSidebar.render()
    @workloads.fetch
      url: '/api/my/workloads/latest'
      success: (workloads) =>
        @viewHomeMain = new Timecard.Views.HomeMain(project_id: id, workloads: workloads)
        @viewHomeMain.render()
        @renderGlobalTimer(workloads)

  renderGlobalTimer: (workloads) ->
    workload = workloads.findWhere(end_at: null)
    if workload?
      @viewWorkloadsTimer = new Timecard.Views.WorkloadsTimer(model: workload)
      @viewWorkloadsTimer.render()
