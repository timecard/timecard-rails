class Timecard.Views.WorkersListItem extends Backbone.View

  template: JST['workers/list_item']

  tagName: 'li'

  className: 'workers-list__item'

  initialize: ->

  render: ->
    @$el.html(@template(
      workload: @model
      user: @model.get('user')
      issue: @model.get('issue')
    ))
    @
