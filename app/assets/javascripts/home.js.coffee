ready = ->
  $('.home').on 'click', '.js-close-issue-button', ->
    $(@).closest('.issue').hide()
  $('.home').on 'click', '.js-reopen-issue-button', ->
    $(@).closest('.issue').hide()
  $('.home').on 'click', '.js-start-workload-button', ->
    Workload.stop() unless @timerId?
  $('.home').on 'click', '.js-stop-workload-button', ->
    Workload.stop()

$(document).ready(ready)
$(document).on('page:change', ready)
