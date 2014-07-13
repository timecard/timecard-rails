class Workload
  @timerId: null
  @start: (start_time) ->
    Workload.replace(Workload.render(start_time))
    @timerId = setInterval ->
      Workload.replace(Workload.render(start_time))
    , 1000
  @stop: ->
    clearInterval(@timerId)
    $('.timer-button--stop').remove()
  @render: (start_time) ->
    end_time = new Date()
    total = end_time.getTime() - start_time.getTime()
    hour = Math.floor(total/(60*60*1000))
    total = total-(hour*60*60*1000)
    min = Math.floor(total/(60*1000))
    total = total-(min*60*1000)
    sec = Math.floor(total/1000)
    hour = "0" + hour if hour < 10
    min = "0" + min if min < 10
    sec = "0" + sec if sec < 10
    "#{hour}:#{min}:#{sec}"

  @replace: (time_str) ->
    $('title').text(time_str)
    $('.timer__field').text(time_str)
