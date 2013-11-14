ready = ->
  $('.projects').on 'click', '.js-close-issue-button', ->
    $(@).closest('.issue').hide()
  $('.projects').on 'click', '.js-reopen-issue-button', ->
    $(@).closest('.issue').hide()
  $('.projects').on 'click', '.js-start-workload-button', ->
    Workload.stop() unless @timerId?
  $('.projects').on 'click', '.js-stop-workload-button', ->
    Workload.stop()

$(document).ready(ready)
$(document).on('page:change', ready)
