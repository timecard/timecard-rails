class Timecard.Views.ProjectsIndex extends Backbone.View

  template: JST['projects/index']

  el: '#page'

  events:
    'click .status': 'status'

  initialize: (@options) ->

  render: ->
    @$el.html(@template())
    @collection.each (model) ->
      @view = new Timecard.Views.ProjectsWidget(model: model)
      @view.render()
    @

  status: (e) ->
    status = $(e.target).data('status')
    @options.router.navigate('#projects/status/'+status, trigger: true)
    false
