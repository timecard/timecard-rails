class Timecard.Models.Issue extends Backbone.Model
  urlRoot: '/api/issues'

  defaults:
    id: null
    subject: ''
    description: ''
    will_start_at: null
    status: 1
    closed_on: null
    project_id: null
    created_at: null
    updated_at: null

  parse: (response) ->
    monthNames = [ 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' ]
    created_at = new Date(response.created_at)
    response.created_on = "#{monthNames[created_at.getMonth()]} #{created_at.getDate()}, #{created_at.getFullYear()}"
    response.project = new Timecard.Models.Project(response.project)
    response.user = new Timecard.Models.User(response.user, parse: true)
    response.assignee = new Timecard.Models.User(response.assignee, parse: true) if response.assignee?
    response.provider = new Timecard.Models.Provider(response.provider) if response.provider?
    response.comments = new Timecard.Collections.Comments(response.comments)
    response
