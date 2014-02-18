class Timecard.Models.Project extends Backbone.Model
  defaults:
    id: null
    name: ''
    description: ''
    is_public: ''
    parent_id: ''
    status: ''
    members: []

  parse: (response) ->
    response.members = new Timecard.Collections.Users(response.members)
    response
