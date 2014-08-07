class Timecard.Views.HomeSidebar extends Backbone.View

  template: JST['home/sidebar']

  el: '.sidebar'

  initialize: (@options) ->
    @projects = @options.projects
    @issues = @options.issues
    @comments = @options.comments
    @workloads = @options.workloads

  render: ->
    @$el.html(@template())
    @projects.fetch
      url: '/api/my/projects'
      success: (collection) =>
        @viewProjectsList = new Timecard.Views.ProjectsList(
          collection: collection
          issues: @issues
          workloads: @workloads
          router: @options.router
        )
        @viewProjectsList.render()

        if @issues.project_id?
          @$(".project-#{@issues.project_id}").closest('li').addClass('project-list__item--current')
        else
          @$(".project-all").closest('li').addClass('project-list__item--current')

    @workloads.fetch
      url: '/api/my/projects/workloads/running'
      success: (collection) ->
        @viewWorkersList = new Timecard.Views.WorkersList(
          collection: collection
        )
        @viewWorkersList.render()

    @comments.fetch
      url: '/api/my/projects/comments'
      success: (collection) ->
        @viewCommentsList = new Timecard.Views.CommentsList(
          collection: collection
        )
        @viewCommentsList.render()
    @
