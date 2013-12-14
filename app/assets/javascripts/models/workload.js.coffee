class Timecard.Models.Workload extends Backbone.Model
  defaults:
    id: ""
    start_at: new Date()
    end_at: ""

  parse: (response, options) ->
    response.start_time = Util.formatTime(response.start_at)
    response.end_time = Util.formatTime(response.end_at)
    response.formatted_duration = Util.formatWorkHours(Date.parse(response.start_at), Date.parse(response.end_at))
    response
