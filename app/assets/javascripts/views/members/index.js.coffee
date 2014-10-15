class Timecard.Views.MembersIndex extends Backbone.View

  el: '.members-index'

  events:
    'keydown .search__field': 'search'

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
