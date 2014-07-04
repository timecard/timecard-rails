class Timecard.Views.CommentsListItem extends Backbone.View

  template: JST['comments/list_item']

  initialize: ->

  tagName: 'li'

  className: 'comments-list__item'

  render: ->
    @$el.html(@template(comment: @model, user: @model.get('user')))
    @
