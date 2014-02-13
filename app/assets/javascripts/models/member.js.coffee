class Timecard.Models.Member extends Backbone.Model
  defaults:
    id: null
    is_admin: ''
    user:
      id: null
      email: ''
      name: ''

  parse: (response) ->
    response.user_id = response.user.id
    response.name = response.user.name
    response.user = new Timecard.Models.User(response.user)
    response
