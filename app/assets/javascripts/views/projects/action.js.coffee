class Timecard.Views.ProjectsAction extends Backbone.View

  template: JST['projects/action']

  el: '#actions'

  events:
    'click .btn-close': 'close'
    'click .btn-archive': 'archive'
    'click .btn-open': 'open'

  initialize: ->

  render: ->
    @$el.html(@template(project: @model))
    @

  close: ->
    @model.save {status: 5},
      patch: true
      success: (model) ->
    false

  archive: ->
    @model.save {status: 9},
      patch: true
      success: (model) ->
    false

  open: ->
    @model.save {status: 1},
      patch: true
      success: (model) ->
    false
