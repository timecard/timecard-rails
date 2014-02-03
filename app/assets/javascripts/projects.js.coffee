ready = ->
  $('.projects').on 'click', '.js-hide-issue', Issue.hide

  $('.projects').on 'click', '.js-start-workload-button', ->
    Workload.stop() unless @timerId?
  $('.projects').on 'click', '.js-stop-workload-button', ->
    Workload.stop()
  $('.projects').on 'click', '.js-stop-workload-password-button', ->
    Workload.stop()
  false

$(document).ready(ready)
$(document).on('page:change', ready)
