class Timecard.Views.IssuesShow extends Backbone.View

  el: '.issues-show'

  initialize: (@options) ->
    @time_entries = @options.time_entries
    @listenTo(@time_entries, 'add change:end_at', @toggle)

  render: ->
    @viewTimeEntriesButtons = new Timecard.Views.TimeEntriesButtons(issue: @model, collection: @time_entries)
    @viewTimeEntriesButtons.render()
    @viewTimeEntriesCrowdworksModal = new Timecard.Views.TimeEntriesCrowdworksModal(issue: @model, collection: @time_entries)

  toggle: ->
    $startButton = @$('.time-entries__start-button')
    $stopButton = @$('.time-entries__stop-button')
    if $startButton.hasClass('hidden')
      $startButton.removeClass('hidden')
      $stopButton.addClass('hidden')
    else
      $startButton.addClass('hidden')
      $stopButton.removeClass('hidden')
