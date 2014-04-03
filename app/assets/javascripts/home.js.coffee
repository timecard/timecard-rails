ready = ->
  $('.home').on 'click', '.js-hide-issue', Issue.hide
  $('.home').on 'click', '.js-start-workload-button', ->
    Workload.stop() unless @timerId?
  $('.home').on 'click', '.js-stop-workload-button', ->
    Workload.stop()

$(document).ready(ready)
$(document).on('page:change', ready)
