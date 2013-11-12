ready = ->
  $('.projects').on 'click', '.js-close-issue-button', ->
    $(@).closest('.issue').hide()
  $('.projects').on 'click', '.js-reopen-issue-button', ->
    $(@).closest('.issue').hide()

$(document).ready(ready)
$(document).on('page:change', ready)
