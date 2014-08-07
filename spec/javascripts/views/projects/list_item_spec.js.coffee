#= require spec_helper

describe 'Timecard.Views.ProjectsListItem', ->
  describe '#show', ->
    beforeEach ->
      @page.html("<div class='sidebar'></div>")
      @projects = new Timecard.Collections.Projects
      @issues = new Timecard.Collections.Issues
      @comments = new Timecard.Collections.Comments
      @workloads = new Timecard.Collections.Workloads
      @router = new Timecard.Routers.Home
      @view = new Timecard.Views.HomeSidebar(
        projects: @projects
        issues: @issues
        comments: @comments
        workloads: @workloads
        router: @router
      )
      @page.html(@view.render().el)
      server.respond()

    it 'assigns specific project to issues url', ->
      $('.project__name--link').click()
      expect(@issues.url).to.eql('/api/my/projects/1/issues')
