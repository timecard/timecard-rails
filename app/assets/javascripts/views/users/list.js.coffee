class Timecard.Views.UsersList extends Backbone.View

  el: '.users-list'

  initialize: ->
    @$el.empty()
    @render()

  render: ->
    @collection.each (user) =>
      @viewUsersListItem = new Timecard.Views.UsersListItem(model: user)
      @$el.append(@viewUsersListItem.render().el)
    @
