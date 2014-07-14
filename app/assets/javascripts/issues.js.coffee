class Issue
  @showEditCommentForm = (e) ->
    e.preventDefault()
    target = $(e.target).closest('.comment-area')
    target.find('form').show()
    target.find('.comment-body').hide()
    target.find('textarea').focus()

  @hideEditComment = (e) ->
    e.preventDefault()
    target = $(e.target)
    target.closest('form').hide()
    target.closest('.comment-area').find('.comment-body').show()

  toggleWillStartAt: (e) ->
    e?.preventDefault()
    $field = $('.issue__will-start-at__field')
    $link = $('.issue__will-start-at__link--add')
    if $field.hasClass('hidden')
      $field.removeClass('hidden')
      $field.find('select').removeAttr('disabled')
      $link.addClass('hidden')
    else
      $field.addClass('hidden')
      $field.find('select').attr('disabled', 'disabled')
      $link.removeClass('hidden')

window.Issue = window.Issue || Issue
window.issue = window.issue || new Issue
