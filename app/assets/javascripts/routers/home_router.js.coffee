class Timecard.Routers.Home extends Backbone.Router
  routes:
    'my/projects/:id': 'show'
    '*path': 'index'

  initialize: ->

  index: ->
    @viewHomeSidebar = new Timecard.Views.HomeSidebar(router: @)
    @viewHomeSidebar.render()
    @viewHomeMain = new Timecard.Views.HomeMain
    @viewHomeMain.render()

  show: (id) ->
    @viewHomeSidebar = new Timecard.Views.HomeSidebar(project_id: id, router: @)
    @viewHomeSidebar.render()
    @viewHomeMain = new Timecard.Views.HomeMain(project_id: id)
    @viewHomeMain.render()
