class Timecard.Views.ProjectsThumbnails extends Backbone.View

  template: JST['projects/thumbnails']

  el: '.contents'

  initialize: ->

  render: ->
    @$el.html(@template())
    @collection.each (project) ->
      @viewProjectsThumbnailsItem = new Timecard.Views.ProjectsThumbnailsItem(model: project)
      @$('.projects-thumbnails').append(@viewProjectsThumbnailsItem.render().el)
    @
