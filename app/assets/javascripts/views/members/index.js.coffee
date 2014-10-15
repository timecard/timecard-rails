class Timecard.Views.MembersIndex extends Backbone.View

  el: '.members-index'

  events:
    'keydown .search__field': 'search'
    'change .member__admin-checkbox': 'updateAuthorization'

  timerId: null

  initialize: (@options) ->
    @projectId = @options.projectId
    @render()

  render: ->

  search: (e) ->
    clearTimeout(@timeId)
    @timeId = setTimeout =>
      query = @$(e.target).val()
      if query.length is 0
        @$('.users-list').empty()
        return
      $.ajax
        type: 'GET'
        url: '/projects/'+@projectId+'/members/search'
        data:
          q: query
        success: (data) =>
          users = new Timecard.Collections.Users(data)
          users.projectId = @projectId
          @viewUsersList = new Timecard.Views.UsersList(collection: users)
        error: ->
    , 1000

  updateAuthorization: (e) ->
    e.preventDefault()
    memberId = $(e.target).data('id')
    if ($(e.target).is(':checked'))
      role = 1
    else
      role = 2
    $.ajax
      type: 'PUT'
      url: '/members/'+memberId
      data:
        member:
          role: role
      success: (data) ->
      error: ->
