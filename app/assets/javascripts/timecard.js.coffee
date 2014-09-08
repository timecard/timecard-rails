window.Timecard =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  mediator: _.extend({}, Backbone.Events)
  timer: _.extend
    id: null
    start: ->
      i = 0
      @id = setInterval ->
        i++
        Timecard.timer.trigger('notify', i)
      , 1000
    stop: ->
      clearInterval(@id)
    , Backbone.Events
  initialize: ->
    routerHome = new Timecard.Routers.Home()
    routerProjects = new Timecard.Routers.Projects()
    Backbone.history.start()

# jquery.blockUI settings
$.blockUI.defaults.css =
  padding:        '0 0 10px 0'
  margin:         0
  width:          '30%'
  top:            '40%'
  left:           '35%'
  textAlign:      'center'
  color:          '#000'
  backgroundColor:'#ffffff'
  cursor:         'wait'
  opacity:        .5
  'border-radius': '10px'

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

  # .issues
  $('.issues').on 'click', '.comment__edit-button', (e) ->
    e.preventDefault()
    $form = $(e.target).closest('.comment').find('form')
    $comment = $(e.target).closest('.comment').find('.comment__body')
    $form.show().find('textarea').focus()
    $comment.hide()

  .on 'click', '.comment__cancel-button', (e) ->
    e.preventDefault()
    $form = $(e.target).closest('.comment').find('form')
    $comment = $(e.target).closest('.comment').find('.comment__body')
    $form.hide()
    $comment.show()

  .on 'click', '.issue__will-start-at__link--add, .issue__will-start-at__link--close', issue.toggleWillStartAt
  .on 'change', '#js-add-github-checkbox', ->
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

  .on 'show.bs.tab', (e) ->
    if $(e.target).hasClass('issue__preview-button')
      body = $('#issue_description').val()
      $preview = $('.issue__description--preview')
      markdown = marked(body)
      if markdown
        $preview.html(markdown)
      else
        $preview.html('<p>Nothing to preview</p>')
    if $(e.target).hasClass('comment__preview-button')
      body = marked($('#comment_body', '#new_comment').val())
      $preview = $('#comment__body--preview')
      if body
        $preview.html(body)
      else
        $preview.html('<p>Nothing to preview</p>')

  .on 'click', '.issue__close-and-comment-button', (e) ->
    e.preventDefault()
    $form = $(e.target).closest('form')
    hidden_el = "<input type='hidden', name='close', value='1' />"
    $form.append(hidden_el)
    $form.submit()

  .on 'click', '.issue__reopen-and-comment-button', (e) ->
    e.preventDefault()
    $form = $(e.target).closest('form')
    hidden_el = "<input type='hidden' name='reopen' value='1' />"
    $form.append(hidden_el)
    $form.submit()

  .on 'keyup', '#comment_body', (e) ->
    $button = $('.issue__comment-and-button')
    if $(e.target).val() is ''
      $button.text($button.data('original-text'))
    else
      $button.text($button.data('comment-text'))

  .on 'click', '.issue__continue-button', (e) ->
    e.preventDefault()
    $form = $(e.target).closest('form')
    hidden_el = "<input type='hidden' name='issue[continue]' value= '1' />"
    $form.append(hidden_el)
    $form.submit()

  # .dashboards
  $('.reports').on 'click', '.js-workloads-on-day-link', (e) ->
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

  $('a[data-toggle="tab"]').tab()

$(document).ready(ready)
$(document).on('page:load', ready)

$ ->
  Timecard.initialize()
