#= require spec_helper

describe 'Timecard.Views.ProjectsListItem', ->
  describe '#show', ->
    beforeEach ->
      @page.html("<div class='sidebar'></div>")
      @router = new Timecard.Routers.Home
      @issues = new Timecard.Collections.Issues
      @workloads = new Timecard.Collections.Workloads
      @view = new Timecard.Views.HomeSidebar(
        issues: @issues
        workloads: @workloads
        router: @router
      )
      @page.html(@view.render().el)
      server.respond()

    it 'assigns specific project to issues url', ->
      $('.project__name--link').click()
      expect(@issues.url).to.eql('/api/my/projects/1/issues')
