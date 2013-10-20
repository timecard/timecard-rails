showEditCommentForm = (e) ->
  $(e.target).closest('.comment-area').find('form').show()
  $(e.target).closest('.comment-area').find('.comment').hide()
  $(e.target).closest('.comment-area').find('textarea').focus()

cancelEditComment = (e) ->
  $(e.target).closest('form').hide()
  $(e.target).closest('.comment-area').find('.comment').show()

$ ->
  $('.issues').on 'click', '.js-edit-comment-button', showEditCommentForm
  $('.issues').on 'click', '.js-cancel-edit-comment-button', cancelEditComment

$(document).on 'page:load', ->
  $('.issues').on 'click', '.js-edit-comment-button', showEditCommentForm
  $('.issues').on 'click', '.js-cancel-edit-comment-button', cancelEditComment
