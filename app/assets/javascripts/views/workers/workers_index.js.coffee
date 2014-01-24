class Timecard.Views.WorkersIndex extends Backbone.View

  template: JST['workers/index']

  el: '#workers'

  initialize: ->
    @$el.html("")

  render: ->
    if @collection.length isnt 0
      $('#workers').removeClass('hidden')
      @collection.each (worker) ->
        @addWorkerView(worker)
      , @
    @

  addWorkerView: (worker) ->
    _id = "worker-#{worker.get('id')}"
    @$el.append(new Timecard.Views.WorkersShow(
      model: worker
      id: _id
      attributes:
        'data-workload-id': worker.get('id')
    ).render().el)
