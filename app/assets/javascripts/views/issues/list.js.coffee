class Timecard.Views.IssuesList extends Backbone.View

  template: JST['issues/list']

  el: '.issue-list__container'

  initialize: (@options) ->
    @listenTo(@collection, 'reset', @render)

  render: ->
    @$el.html(@template())
    if @collection.length is 0
      @$('.issue-list').append("<li class='media issue-list__item'><p>You don't have any assigned issue.</p></li>")
    else
      @collection.each (issue) ->
        @addIssueView(issue)
      , @
      @viewWorkloadsCrowdworksModal = new Timecard.Views.WorkloadsCrowdworksModal(issues: @collection, workloads: @options.workloads)
      @viewWorkloadsCrowdworksModal.render()
    @
  
  addIssueView: (issue) ->
    @$('.issue-list').append(new Timecard.Views.IssuesItem(model: issue, workloads: @options.workloads).render().el)
