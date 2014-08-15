class Timecard.Collections.TimeEntries extends Backbone.PageableCollection
  model: Timecard.Models.TimeEntry

  url: ->
    if @current_user
      '/api/user/time_entries'
