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

$(document).ready(ready)
$(document).on('page:load', ready)

$ ->
  Timecard.initialize()
