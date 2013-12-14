class Timecard.Views.WorkloadsTable extends Backbone.View

  template: JST['workloads/table']

  el: "#workloads-table"

  initialize: (options) ->
    @workloads = options.workloads

  render: ->
    @$el.html(@template(workloads: @workloads))
    @
