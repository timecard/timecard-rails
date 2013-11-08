class Issue
  @hide = (e) ->
    $(e.target).closest('.issue').hide()

  @showEditCommentForm = (e) ->
    $(e.target).closest('.comment-area').find('form').show()
    $(e.target).closest('.comment-area').find('.comment').hide()
    $(e.target).closest('.comment-area').find('textarea').focus()

  @hideEditComment = (e) ->
    $(e.target).closest('form').hide()
    $(e.target).closest('.comment-area').find('.comment').show()

ready = ->
  $('.issues').on 'click', '.js-edit-comment-button', Issue.showEditCommentForm
  $('.issues').on 'click', '.js-cancel-edit-comment-button', Issue.hideEditComment
  $('.js-close-issue-button').on 'click', Issue.hide
  $('.js-reopen-issue-button').on 'click', Issue.hide

$(document).ready(ready)
$(document).on('page:change', ready)
