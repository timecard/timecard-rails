class Timecard.Views.IssuesItem extends Backbone.View

  template: JST['issues/item']

  events:
    'click .js-btn-close-issue': 'closeIssue'
    'click .js-btn-reopen-issue': 'reopenIssue'
    'click .js-btn-postpone-issue': 'postponeIssue'
    'click .js-btn-do-today-issue': 'doTodayIssue'
    'click .js-btn-start-workload': 'startWorkload'
    'click .js-btn-stop-workload': 'stopWorkload'
    'click .js-btn-stop-workload-password': 'stopWorkloadAndPassword'
    'mouseover': 'showActions'
    'mouseleave': 'hideActions'

  tagName: 'li'

  className: 'media issue-list__item'

  initialize: ->
    @listenTo(@model, 'change:status', @remove)
    @listenTo(@model, 'change:will_start_at', @remove)

  render: ->
    @$el.html(@template(issue: @model))
    @

  closeIssue: (e) ->
    e.preventDefault()
    if (window.confirm("Are you sure you wish to close?"))
      @model.save {status: 9},
        url: @model.urlRoot+'/'+@model.id+'/close'
        patch: true
        success: (model) ->

  reopenIssue: (e) ->
    e.preventDefault()
    @model.save {status: 1},
      url: @model.urlRoot+'/'+@model.id+'/reopen'
      patch: true
      success: (model) ->

  postponeIssue: (e) ->
    e.preventDefault()
    today = new Date()
    tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000))
    @model.save {will_start_at: tomorrow},
      patch: true
      success: (model) ->

  doTodayIssue: (e) ->
    e.preventDefault()
    @model.save {will_start_at: new Date()},
      patch: true
      success: (model) ->

  startWorkload: (e) ->
    @workload = new Timecard.Models.Workload()
    @workload.save { start_at: new Date() },
      url: '/issues/'+@model.id+'/workloads'
      success: (model) ->
        workload = new Timecard.Models.Workload(model)
        issue = new Timecard.Models.Issue(model.get('issue'))
        @viewIssuesItem = new Timecard.Views.IssuesItem(model: issue)
        $("#issue-#{issue.id}").closest('.media').replaceWith(@viewIssuesItem.render().el)
        if model.get('prev_issue')?
          Workload.stop()
          prev_issue = new Timecard.Models.Issue(model.get('prev_issue'))
          @viewIssuesItem = new Timecard.Views.IssuesItem(model: prev_issue)
          $("#issue-#{prev_issue.id}").closest('.media').replaceWith(@viewIssuesItem.render().el)
        @workers = new Timecard.Collections.Workers()
        @workers.fetch
          success: (collection) ->
            @viewWorkersIndex = new Timecard.Views.WorkersIndex(collection: collection)
            @viewWorkersIndex.render().el
        @viewWorkloadsTimer = new Timecard.Views.WorkloadsTimer(model: model)
        @viewWorkloadsTimer.render()
        Workload.start(new Date(model.get('start_at')))
        $('.timer').removeClass('timer--off')
        $('.timer').addClass('timer--on')
    false

  stopWorkload: (e) ->
    workload_id = $(e.currentTarget).data('workload-id')
    $.ajax
      url: '/workloads/' + workload_id + '/stop'
      data:
        JSON.stringify({ workload: { end_at: new Date() } })
      type: 'PATCH'
      dataType: 'json'
      contentType: 'application/json'
      success: (data, textStatus, jqXHR) ->
        issue = new Timecard.Models.Issue(data.issue)
        @viewIssuesItem = new Timecard.Views.IssuesItem(model: issue)
        $("#issue-#{issue.id}").closest('.media').replaceWith(@viewIssuesItem.render().el)
        @workers = new Timecard.Collections.Workers()
        @workers.fetch
          success: (collection) ->
            @viewWorkersIndex = new Timecard.Views.WorkersIndex(collection: collection)
            @viewWorkersIndex.render().el
        Workload.stop()
    false

  stopWorkloadAndPassword: (e) ->
    workload_id = $(e.currentTarget).data('workload-id')
    @pass = $('#password' + workload_id.toString()).val()
    $.ajax
      url: '/workloads/' + workload_id + '/stop'
      data:
        JSON.stringify({ workload: { end_at: new Date() }, password: @pass })
      type: 'PATCH'
      dataType: 'json'
      contentType: 'application/json'
      success: (data, textStatus, jqXHR) ->
        issue = new Timecard.Models.Issue(data.issue)
        @viewIssuesItem = new Timecard.Views.IssuesItem(model: issue)
        $("#issue-#{issue.id}").closest('.media').replaceWith(@viewIssuesItem.render().el)
        @workers = new Timecard.Collections.Workers()
        @workers.fetch
          success: (collection) ->
            @viewWorkersIndex = new Timecard.Views.WorkersIndex(collection: collection)
            @viewWorkersIndex.render().el
        Workload.stop()
    false

  showActions: ->
    @$('.issue__actions').removeClass('hidden')
    @$el.addClass('highlight')

  hideActions: ->
    @$('.issue__actions').addClass('hidden')
    @$el.removeClass('highlight')

  remove: ->
    @$el.remove()
