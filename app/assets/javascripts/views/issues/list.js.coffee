class Timecard.Views.IssuesList extends Backbone.View

  template: JST['issues/list']

  el: '.issue-list__container'

  initialize: ->
    @listenTo(@collection, 'reset', @render)

  render: ->
    @$el.html(@template())
    if @collection.length is 0
      @$('.issue-list').append("<li class='media'><p>You don't have assigned issue.</p></li>")
    else
      @collection.each (issue) ->
        @addIssueView(issue)
      , @
    @
  
  addIssueView: (issue) ->
    @$('.issue-list').append(new Timecard.Views.IssuesItem(model: issue).render().el)
