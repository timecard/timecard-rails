class Timecard.Collections.Workloads extends Backbone.Collection
  url: '/workloads'
  model: Timecard.Models.Workload

  total_duration: ->
    totalStartAt = _.reduce @models, (memo, model) ->
      memo += Date.parse(model.get('start_at'))
    , 0
    totalEndAt = _.reduce @models, (memo, model) ->
      memo += Date.parse(model.get('end_at'))
    , 0
    duration = totalEndAt - totalStartAt
    hour = Math.floor(duration/(60*60*1000))
    duration = duration-(hour*60*60*1000)
    min = Math.floor(duration/(60*1000))
    duration = duration-(min*60*1000)
    sec = Math.floor(duration/1000)
    hour = "0" + hour if hour < 10
    min = "0" + min if min < 10
    sec = "0" + sec if sec < 10
    "#{hour}:#{min}:#{sec}"
