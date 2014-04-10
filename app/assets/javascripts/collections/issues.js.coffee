class Timecard.Collections.Issues extends Backbone.Collection
  url: "/issues"

  model: Timecard.Models.Issue

  parse: (response) ->
    @last_page = response.last_page
    @next_page = response.current_page + 1 unless @last_page
    response.issues
