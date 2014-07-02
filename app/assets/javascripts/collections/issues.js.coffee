class Timecard.Collections.Issues extends Backbone.Collection
  url: "/issues"

  model: Timecard.Models.Issue

  parse: (response) ->
    @total_pages = response.total_pages
    @current_page = response.current_page
    response.issues
