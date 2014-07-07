class Timecard.Models.Comment extends Backbone.Model

  defaults:
    id: null
    body: ''
    created_at: null
    updated_at: null

  parse: (response) ->
    response.user = new Timecard.Models.User(response.user, parse: true)
    response.issue = new Timecard.Models.Issue(response.issue, parse: true)
    response

  createdFromNow: ->
    time = new Date(@created_at)
    moment(time).fromNow()
