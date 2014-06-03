class Timecard.Routers.Home extends Backbone.Router
  routes:
    'my/projects/:id': 'show'
    '*path': 'index'

  initialize: ->
    @issues = new Timecard.Collections.Issues()
    if $('.login').hasClass('true')
      @workers = new Timecard.Collections.Workers()
      @workers.fetch
        success: (collection) ->
          if collection.length > 0
            @viewWorkersIndex = new Timecard.Views.WorkersIndex(collection: collection)
            @viewWorkersIndex.render().el
            user_id = $('#workers').data('user-id')
            current_user = collection.get(user_id)
            if current_user?
              workload = new Timecard.Models.Workload(current_user.get('workload'))
              Workload.start(new Date(workload.get('start_at')))

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
