class Timecard.Views.HomeMain extends Backbone.View

  initialize: ->
    @projects = new Timecard.Collections.Projects

  render: ->
    @projects.fetch
      url: '/api/my/projects'
      success: (collection) ->
        @viewProjectsThumbnails = new Timecard.Views.ProjectsThumbnails(collection: collection)
        @viewProjectsThumbnails.render()
    @
