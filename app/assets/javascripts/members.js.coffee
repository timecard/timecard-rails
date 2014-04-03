ready = ->
  $('.members').on 'mouseenter', 'li.member', ->
    $(this).addClass('select')
  $('.members').on 'mouseleave', 'li.member', ->
    $(this).removeClass('select')

$(document).ready(ready)
$(document).on('page:load', ready)
