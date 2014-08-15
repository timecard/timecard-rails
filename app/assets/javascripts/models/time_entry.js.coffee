class Timecard.Models.TimeEntry extends Backbone.Model

  formatted_duration: ->
    hour = Math.floor(@duration()/(60*60*1000))
    duration = @duration()-(hour*60*60*1000)
    min = Math.floor(duration/(60*1000))
    duration = duration-(min*60*1000)
    sec = Math.floor(duration/1000)
    hour = "0" + hour if hour < 10
    min = "0" + min if min < 10
    sec = "0" + sec if sec < 10
    "#{hour}:#{min}:#{sec}"

  duration: ->
    @stopped_at_or_now() - Date.parse(@.get('start_at'))

  stopped_at_or_now: ->
    if @get('end_at')?
      Date.parse(@get('end_at'))
    else
      new Date()
