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

ready = ->
  $('.issues').on 'click', '.js-edit-comment-button', Issue.showEditCommentForm
  $('.issues').on 'click', '.js-cancel-edit-comment-button', Issue.hideEditComment
  $('.issues').on 'click', '.js-add-will-start-at', Issue.showWillStartAt
  $('.issues').on 'click', '.js-close-will-start-at', Issue.hideWillStartAt
  $('.issues').on 'change', '#js-add-github-checkbox', ->
    $('#js-assignee-select-box').html('<img src="/assets/loading_mini.gif" alt="loading..." />')
    project_id = $('#new_issue, .edit_issue').data('project-id')
    checked = if $(@).prop('checked') then '1' else ''
    @members = new Timecard.Collections.Members()
    @members.fetch
      url: "/projects/#{project_id}"+@members.url
      data:
        github: checked
      success: (collection) ->
        @viewAssigneeSelectBox =
          new Timecard.Views.IssuesAssigneeSelectBox(collection: collection)
        @viewAssigneeSelectBox.render()
  false

$(document).ready(ready)
$(document).on('page:change', ready)
