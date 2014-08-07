class Timecard.Collections.Issues extends Backbone.PageableCollection
  url: "/issues"

  model: Timecard.Models.Issue

  status: 'open'

  parse: (response) ->
    @state.totalPages = response.total_pages
    @state.lastPage = response.total_pages
    response = response.issues
    response

  state: {
    pageSize: 10
  }
