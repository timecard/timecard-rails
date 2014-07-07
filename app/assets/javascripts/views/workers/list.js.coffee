class Timecard.Views.WorkersList extends Backbone.View

  template: JST['workers/list']

  el: '.workers'

  initialize: ->

  render: ->
    @$el.html(@template())
    if @collection.length is 0
      @$('.workers-list').append("<li><p class='text-muted'>No one has work</p></li>")
    else
      @collection.each (worker) ->
        @viewWorkerListItem = new Timecard.Views.WorkersListItem(model: worker)
        @$('.workers-list').append(@viewWorkerListItem.render().el)
    @
