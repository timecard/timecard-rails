ready = ->
  $('.home').on 'click', '.js-close-issue-button', ->
    $(@).closest('.issue').hide()
  $('.home').on 'click', '.js-reopen-issue-button', ->
    $(@).closest('.issue').hide()

$(document).ready(ready)
$(document).on('page:change', ready)
