class Timecard.Views.UsersListItem extends Backbone.View

  template: JST['users/list_item']

  tagName: 'li'

  className: 'users-list__item'

  events:
    'click .users-list__add-link': 'addMember'

  initialize: ->
    @render()

  render: ->
    @$el.html(@template(user: @model))
    @

  addMember: (e) ->
    e.preventDefault()
    $.ajax
      type: 'POST'
      url: '/projects/'+@model.collection.projectId+'/members'
      data:
        user_id: @model.id
      success: (data) =>
        $('.search__field').val('')
        @remove()
      error: ->
