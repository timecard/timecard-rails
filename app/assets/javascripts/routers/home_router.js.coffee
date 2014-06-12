class Timecard.Routers.Home extends Backbone.Router
  routes:
    'my/projects/:id': 'show'
    '*path': 'index'

  initialize: ->
    @issues = new Timecard.Collections.Issues
    @workloads = new Timecard.Collections.Workloads

  index: ->
    @viewHomeSidebar = new Timecard.Views.HomeSidebar(issues: @issues, router: @)
    @viewHomeSidebar.render()
    @workloads.fetch
      url: '/api/my/workloads/latest'
      success: (workloads) =>
        @viewHomeMain = new Timecard.Views.HomeMain(issues: @issues, workloads: workloads)
        @viewHomeMain.render()
        @renderGlobalTimer(workloads)

  show: (id) ->
    @viewHomeSidebar = new Timecard.Views.HomeSidebar(project_id: id, issues: @issues, router: @)
    @viewHomeSidebar.render()
    @workloads.fetch
      url: '/api/my/workloads/latest'
      success: (workloads) =>
        @viewHomeMain = new Timecard.Views.HomeMain(project_id: id, issues: @issues, workloads: workloads)
        @viewHomeMain.render()
        @renderGlobalTimer(workloads)

  renderGlobalTimer: (workloads) ->
    workload = workloads.findWhere(end_at: null)
    if workload?
      @viewWorkloadsTimer = new Timecard.Views.WorkloadsTimer(model: workload, issues: @issues)
      @viewWorkloadsTimer.render()
