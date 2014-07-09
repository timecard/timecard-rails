class Timecard.Views.WorkersList extends Backbone.View

  template: JST['workers/list']

  el: '.workers-list__container'
  
  events:
    'click .workers-reload': 'reloadWorkersList'

  initialize: ->
    @listenTo(@collection, 'reset', @render)

  render: ->
    @$el.html(@template())
    if @collection.length is 0
      @$('.workers-list').append("<li><p class='text-muted'>No one has work</p></li>")
    else
      @collection.each (worker) ->
        @viewWorkerListItem = new Timecard.Views.WorkersListItem(model: worker)
        @$('.workers-list').append(@viewWorkerListItem.render().el)
    @

  reloadWorkersList: (e) ->
    e.preventDefault()
    new Timecard.Views.IssuesLoading(el: @$('.workers-list'))
    @collection.fetch
      url: '/api/my/projects/workloads/running'
      reset: true
      success: (collection) ->
