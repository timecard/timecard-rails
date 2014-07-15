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

  issuesCountLabel: ->
    open_issues_count = @get('open_issues_count')
    return 'No issues' if open_issues_count is 0
    return "#{open_issues_count} issue" if open_issues_count is 1
    return "#{open_issues_count} issues"
