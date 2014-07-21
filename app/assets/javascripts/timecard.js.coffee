window.Timecard =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    routerHome = new Timecard.Routers.Home()
    routerProjects = new Timecard.Routers.Projects()
    Backbone.history.start()

ready = ->
  host = window.document.location.host
  if host.match(/dev$/)
    # development mode
    dispatcher = new WebSocketRails('localhost:3000/websocket')
  else
    # production mode
    dispatcher = new WebSocketRails("#{window.document.location.host}/websocket")
  channel = dispatcher.subscribe('streaming')
  channel.bind 'create', (comment) ->
    comments = new Timecard.Collections.Comments
    comments.fetch
      url: '/api/my/projects/comments'
      success: (collection) ->
        viewCommentsList = new Timecard.Views.CommentsList(collection: collection)
        viewCommentsList.render()

  # .projects
  $('.projects').on 'click', '.js-hide-issue', Issue.hide

  $('.projects').on 'click', '.js-start-workload-button', ->
    Workload.stop() unless @timerId?
  $('.projects').on 'click', '.js-stop-workload-button', ->
    Workload.stop()
  $('.projects').on 'click', '.js-stop-workload-password-button', ->
    Workload.stop()

  # .issues
  $('.issues').on 'click', '.comment__edit-button', (e) ->
    e.preventDefault()
    $form = $(e.target).closest('.comment').find('form')
    $comment = $(e.target).closest('.comment').find('.comment__body')
    $form.show().find('textarea').focus()
    $comment.hide()

  $('.issues').on 'click', '.comment__cancel-button', (e) ->
    e.preventDefault()
    $form = $(e.target).closest('.comment').find('form')
    $comment = $(e.target).closest('.comment').find('.comment__body')
    $form.hide()
    $comment.show()

  $('.issues').on 'click', '.issue__will-start-at__link--add, .issue__will-start-at__link--close', issue.toggleWillStartAt
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
    if checked is '1'
      $('.issue__labels').show()
    else
      $('.issue__labels').hide()

  # .dashboards
  $('.dashboards').on 'click', '.js-workloads-on-day-link', (e) ->
    e.preventDefault()
    user_id = $('#user-name').data('user-id')
    year = $(@).data('year')
    month = $(@).data('month')
    day = $(@).data('day')
    @collection = new Timecard.Collections.Workloads()
    @collection.fetch
      url: "/users/#{user_id}/workloads/#{year}/#{month}/#{day}"
      success: (workloads) =>
        $(@).closest('ul').find('li.active').removeClass('active')
        $(@).closest('li').addClass('active')
        @viewsWorkloadsTable = new Timecard.Views.WorkloadsTable(workloads: workloads)
        @viewsWorkloadsTable.render()

  # .members
  $('.members').on 'mouseenter', 'li.member', ->
    $(this).addClass('select')
  $('.members').on 'mouseleave', 'li.member', ->
    $(this).removeClass('select')

$(document).ready(ready)
$(document).on('page:load', ready)

$ ->
  Timecard.initialize()
