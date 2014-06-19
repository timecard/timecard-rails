class Timecard.Models.User extends Backbone.Model

  defaults:
    id: null
    email: ''
    name: ''
    image: ''

  parse: (response) ->
    hash = md5(response.email)
    response.image = "https://www.gravatar.com/avatar/#{hash}?s=50"
    response
