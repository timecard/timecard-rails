class Timecard.Views.CommentsList extends Backbone.View

  template: JST['comments/list']

  el: '.comments-list__container'

  initialize: ->

  render: ->
    @$el.html(@template())
    @collection.each (comment) ->
      @viewCommentsListItem = new Timecard.Views.CommentsListItem(model: comment)
      @$('.comments-list').append(@viewCommentsListItem.render().el)
    @
