class Timecard.Collections.Workloads extends Backbone.Collection
  url: "/workloads"
  model: Timecard.Models.Workload

  parse: (response, options) ->
    totalStartAt = _.reduce response, (memo, model) ->
      memo += Date.parse(model.start_at)
    , 0
    totalEndAt = _.reduce response, (memo, model) ->
      memo += Date.parse(model.end_at)
    , 0
    @.formatted_total_hours = Util.formatWorkHours(totalStartAt, totalEndAt)
    response
