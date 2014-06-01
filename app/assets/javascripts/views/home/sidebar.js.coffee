class Timecard.Views.HomeSidebar extends Backbone.View

  template: JST['home/sidebar']

  el: '.sidebar'

  initialize: ->
    @projects = new Timecard.Collections.Projects

  render: ->
    @$el.html(@template())
    @projects.fetch
      url: '/api/my/projects'
      success: (collection) ->
        @viewProjectsList = new Timecard.Views.ProjectsList(collection: collection)
        @viewProjectsList.render()
    @
