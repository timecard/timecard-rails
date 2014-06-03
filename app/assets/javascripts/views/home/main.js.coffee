class Timecard.Views.HomeMain extends Backbone.View

  initialize: (@options) ->
    @projects = new Timecard.Collections.Projects

  render: ->
    @projects.fetch
      url: '/api/my/projects'
      success: (collection) =>
        if @options?.project_id?
          @project = collection.get(@options.project_id)
          @viewIssuesIndex = new Timecard.Views.IssuesIndex(project: @project)
          @viewIssuesIndex.render()
        else
          @viewProjectsThumbnails = new Timecard.Views.ProjectsThumbnails(collection: collection)
          @viewProjectsThumbnails.render()
    @
