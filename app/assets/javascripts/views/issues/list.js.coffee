class Timecard.Views.IssuesList extends Backbone.View

  template: JST['issues/list']

  el: '.issue-list__container'

  initialize: (@options) ->
    @listenTo(@collection, 'reset', @render)

  render: ->
    @$el.html(@template())
    @renderIssuesList()
    if @collection.total_pages > 1 and @collection.total_pages > @collection.current_page
      @viewIssuesListPagination = new Timecard.Views.IssuesListPagination(collection: @collection, workloads: @options.workloads)
      @viewIssuesListPagination.render()
    @viewWorkloadsCrowdworksModal = new Timecard.Views.WorkloadsCrowdworksModal(issues: @collection, workloads: @options.workloads)
    @viewWorkloadsCrowdworksModal.render()
    @

  renderIssuesList: ->
    if @collection.length is 0
      @$('.issue-list').append("<li class='media issue-list__item'><p>You don't have any assigned issue.</p></li>")
    else
      @collection.each (issue) ->
        @addIssueView(issue)
      , @
  
  addIssueView: (issue) ->
    @$('.issue-list').append(new Timecard.Views.IssuesItem(model: issue, workloads: @options.workloads).render().el)
