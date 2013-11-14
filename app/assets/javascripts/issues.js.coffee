class Issue
  @showEditCommentForm = (e) ->
    e.preventDefault()
    target = $(e.target).closest('.comment-area')
    target.find('form').show()
    target.find('.comment').hide()
    target.find('textarea').focus()

  @hideEditComment = (e) ->
    e.preventDefault()
    target = $(e.target)
    target.closest('form').hide()
    target.closest('.comment-area').find('.comment').show()

  @hide = (e) ->
    e.preventDefault()
    $(e.target).closest('.issue').hide()

window.Issue = window.Issue || Issue

ready = ->
  $('.issues').on 'click', '.js-edit-comment-button', Issue.showEditCommentForm
  $('.issues').on 'click', '.js-cancel-edit-comment-button', Issue.hideEditComment
  false

$(document).ready(ready)
$(document).on('page:change', ready)
