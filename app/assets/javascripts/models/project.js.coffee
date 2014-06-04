class Timecard.Models.Project extends Backbone.Model
  urlRoot: '/projects'

  defaults:
    id: null
    name: ''
    description: ''
    is_public: ''
    parent_id: 0
    status: ''

  parse: (response) ->
    response.publicity = if response.is_public then 'Public' else 'Private'
    response
