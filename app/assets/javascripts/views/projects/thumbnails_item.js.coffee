class Timecard.Views.ProjectsThumbnailsItem extends Backbone.View

  template: JST['projects/thumbnails_item']

  className: 'projects-thumbnails__layout col-md-4'

  initialize: ->

  render: ->
    @$el.html(@template(project: @model))
    @
