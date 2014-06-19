class Timecard.Routers.Home extends Backbone.Router
  routes:
    'my/projects': 'index'
    'my/projects/:id': 'show'
    '*path': 'index'

  initialize: ->
    @issues = new Timecard.Collections.Issues
    @workloads = new Timecard.Collections.Workloads

  index: ->
    return if $('.login').hasClass('false')
    @workloads.fetch
      url: '/api/my/workloads/latest'
      success: (workloads) =>
        @viewHomeSidebar = new Timecard.Views.HomeSidebar(issues: @issues, workloads: workloads, router: @)
        @viewHomeSidebar.render()
        @viewHomeMain = new Timecard.Views.HomeMain(issues: @issues, workloads: workloads)
        @viewHomeMain.render()
        @renderGlobalTimer(workloads)

  show: (id) ->
    @workloads.fetch
      url: '/api/my/workloads/latest'
      success: (workloads) =>
        @viewHomeSidebar = new Timecard.Views.HomeSidebar(project_id: id, issues: @issues, workloads: workloads, router: @)
        @viewHomeSidebar.render()
        @viewHomeMain = new Timecard.Views.HomeMain(project_id: id, issues: @issues, workloads: workloads)
        @viewHomeMain.render()
        @renderGlobalTimer(workloads)

  renderGlobalTimer: (workloads) ->
    workload = workloads.findWhere(end_at: null)
    if workload?
      @viewWorkloadsTimer = new Timecard.Views.WorkloadsTimer(model: workload, issues: @issues)
      @viewWorkloadsTimer.render()
