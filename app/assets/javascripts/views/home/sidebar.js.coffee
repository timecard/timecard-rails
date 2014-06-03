class Timecard.Views.HomeSidebar extends Backbone.View

  template: JST['home/sidebar']

  el: '.sidebar'

  initialize: (@options) ->
    @projects = new Timecard.Collections.Projects
    Backbone.on('navigate', @navigate, @)

  render: ->
    @$el.html(@template())
    @projects.fetch
      url: '/api/my/projects'
      success: (collection) ->
        @viewProjectsList = new Timecard.Views.ProjectsList(collection: collection)
        @viewProjectsList.render()
    @

  navigate: (project) ->
    @options.router.navigate('/my/projects/'+project.id, trigger: false)
