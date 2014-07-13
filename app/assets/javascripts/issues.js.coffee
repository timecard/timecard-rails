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

  @hide = (e) ->
    e.preventDefault()
    $(e.target).closest('.issue').hide()

  @showWillStartAt = (e) ->
    $(e.target).closest('.form-group').addClass('hidden')
    $('#will-start-at').removeClass('hidden')
    $('#will-start-at').find('select').removeAttr('disabled')
    false

  @hideWillStartAt = (e) ->
    $(e.target).closest('.form-group').addClass('hidden')
    $('#add-will-start-at').removeClass('hidden')
    $('#will-start-at').find('select').attr('disabled', 'disabled')
    false

window.Issue = window.Issue || Issue
