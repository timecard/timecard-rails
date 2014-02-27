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
    'mouseover .issue': 'showActions'
    'mouseleave .issue': 'hideActions'

  className: 'media'

  initialize: ->

  render: ->
    @$el.html(@template(issue: @model))
    @

  closeIssue: (e) ->
    if (window.confirm("Are you sure you wish to close?"))
      @model.save {},
        url: @model.urlRoot+'/'+@model.id+'/close'
        patch: true
        success: (model) =>
          $("#issue-#{@model.id}").closest('.media').hide(500, ->
            @.remove()
          )
    false

  reopenIssue: (e) ->
    @model.save {},
      url: @model.urlRoot+'/'+@model.id+'/reopen'
      patch: true
      success: (model) =>
        $("#issue-#{@model.id}").closest('.media').hide(500, ->
          @.remove()
        )
    false

  postponeIssue: (e) ->
    @model.save {},
      url: @model.urlRoot+'/'+@model.id+'/postpone'
      patch: true
      success: (model) =>
        $("#issue-#{@model.id}").closest('.media').hide(500, ->
          @.remove()
        )
    false

  doTodayIssue: (e) ->
    @model.save {},
      url: @model.urlRoot+'/'+@model.id+'/do_today'
      patch: true
      success: (model) =>
       $("#issue-#{@model.id}").closest('.media').hide(500, ->
          @.remove()
        )
    false

  startWorkload: (e) ->
    @workload = new Timecard.Models.Workload()
    @workload.save { start_at: new Date() },
      url: @model.urlRoot + '/' + @model.id + '/workloads/start'
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
        Workload.start(new Date(model.get('start_at')))
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
    $('.actions', @$el).removeClass('hidden')
    $(@$el).closest('.media').addClass('highlight')

  hideActions: ->
    $('.actions', @$el).addClass('hidden')
    $(@$el).closest('.media').removeClass('highlight')
