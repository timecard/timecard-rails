class Timecard.Models.Workload extends Backbone.Model
  urlRoot: '/workloads'

  defaults:
    id: null
    start_at: new Date()
    end_at: null

  parse: (response) ->
    response.issue = new Timecard.Models.Issue(response.issue, parse: true)
    response.start_time = Util.formatTime(response.start_at)
    response.end_time = Util.formatTime(response.end_at)
    response.formatted_duration = Util.formatWorkHours(Date.parse(response.start_at), Date.parse(response.end_at))
    response
