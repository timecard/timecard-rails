class Timecard.Routers.Home extends Backbone.Router
  routes:
    'my/projects': 'index'
    'my/projects/:id': 'show'
    '*path': 'index'

  initialize: ->
    @projects = new Timecard.Collections.Projects
    @issues = new Timecard.Collections.Issues
    @workloads = new Timecard.Collections.Workloads

  index: ->
    return if $('.login').hasClass('false')
    @viewHomeSidebar = new Timecard.Views.HomeSidebar(issues: @issues, workloads: @workloads, router: @)
    @viewHomeSidebar.render()
    @viewHomeMain = new Timecard.Views.HomeMain(issues: @issues, workloads: @workloads)
    @viewHomeMain.render()
    @renderGlobalTimer()

  show: (id) ->
    @projects.fetch
      url: '/api/my/projects'
      success: (projects) =>
        project = projects.get(id)
        @viewHomeSidebar = new Timecard.Views.HomeSidebar(project_id: id, issues: @issues, workloads: @workloads, router: @)
        @viewHomeSidebar.render()
        @viewHomeMain = new Timecard.Views.HomeMain(project: project, issues: @issues, workloads: @workloads)
        @viewHomeMain.render()
    @renderGlobalTimer()

  renderGlobalTimer: ->
    @workloads.fetch
      url: '/api/my/workloads/latest'
      success: (workloads) =>
        workload = workloads.findWhere(end_at: null)
        if workload?
          @viewWorkloadsTimer = new Timecard.Views.WorkloadsTimer(model: workload, issues: @issues)
          @viewWorkloadsTimer.render()
