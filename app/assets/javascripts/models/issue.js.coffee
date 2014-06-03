class Timecard.Models.Issue extends Backbone.Model
  urlRoot: '/issues'

  defaults:
    id: null
    subject: ''
    description: ''
    will_start_at: null
    status: 1
    closed_on: null
    project_id: null
    author_id: null
    assignee_id: null
