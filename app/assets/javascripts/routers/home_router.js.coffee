class Timecard.Routers.Home extends Backbone.Router
  routes:
    'my/projects': 'index'
    'my/projects/:id': 'show'
    '*path': 'index'

  initialize: ->
    @projects = new Timecard.Collections.Projects
    @issues = new Timecard.Collections.Issues
    @comments = new Timecard.Collections.Comments
    @workloads = new Timecard.Collections.Workloads
    @time_entries = new Timecard.Collections.TimeEntries
    @time_entries.current_user = true

  index: ->
    return if $('.login').hasClass('false')
    @renderGlobalTimer()
    return if $('.home').length is 0
    @issues.project_id = null
    @issues.url = '/api/my/issues'
    @viewHomeSidebar = new Timecard.Views.HomeSidebar(
      projects: @projects
      issues: @issues
      comments: @comments
      workloads: @workloads
      router: @
    )
    @viewHomeSidebar.render()
    @viewHomeMain = new Timecard.Views.HomeMain(
      projects: @projects
      issues: @issues
      workloads: @workloads
    )
    @viewHomeMain.render()

  show: (id) ->
    return if $('.login').hasClass('false')
    @renderGlobalTimer()
    return if $('.home').length is 0
    @issues.project_id = id
    @issues.url = '/api/my/projects/'+id+'/issues'
    @viewHomeSidebar = new Timecard.Views.HomeSidebar(
      projects: @projects
      issues: @issues
      comments: @comments
      workloads: @workloads
      router: @
    )
    @viewHomeSidebar.render()
    @viewHomeMain = new Timecard.Views.HomeMain(
      projects: @projects
      issues: @issues
      workloads: @workloads
    )
    @viewHomeMain.render()

  renderGlobalTimer: ->
    if $('.timer').hasClass('timer--on')
      @time_entries.fetch
        success: (collection) ->
          time_entry = collection.at(0)
          @viewTimerContainer = new Timecard.Views.TimerContainer(model: time_entry)
          @viewTimerContainer.render()
