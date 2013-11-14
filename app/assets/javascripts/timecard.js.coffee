ready = ->
  start_time = $("body").data('timer')
  start_time = new Date(Date.parse(start_time))
  if not isNaN(start_time)
    Workload.start(start_time)

$(document).ready(ready)
$(document).on('page:change', ready)
