class Timecard.Views.IssuesShow extends Backbone.View

  template: JST['issues/show']

  events:
    'click .js-close-issue-button': 'closeIssue'
    'click .js-reopen-issue-button': 'reopenIssue'
    'click .js-postpone-issue-button': 'postponeIssue'
    'click .js-do-today-issue-button': 'doTodayIssue'
    'click .js-start-workload-button': 'startWorkload'
    'click .js-stop-workload-button': 'stopWorkload'

  className: 'media'

  initialize: (@options) ->
    @issue = @options.issue

  render: ->
    @$el.html(@template(issue: @issue))
    @

  closeIssue: (e) ->
    e.preventDefault()
    e.stopPropagation()
    if (window.confirm("Are you sure you wish to close?"))
      @issue.save {},
        url: @issue.urlRoot+'/'+@issue.id+'/close'
        patch: true
        success: (model) =>
          $("#issue-#{@issue.id}").closest('.media').hide(500, ->
            @.remove()
          )
    else
      false

  reopenIssue: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @issue.save {},
      url: @issue.urlRoot+'/'+@issue.id+'/reopen'
      patch: true
      success: (model) =>
        $("#issue-#{@issue.id}").closest('.media').hide(500, ->
          @.remove()
        )

  postponeIssue: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @issue.save {},
      url: @issue.urlRoot+'/'+@issue.id+'/postpone'
      patch: true
      success: (model) =>
        $("#issue-#{@issue.id}").closest('.media').hide(500, ->
          @.remove()
        )

  doTodayIssue: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @issue.save {},
      url: @issue.urlRoot+'/'+@issue.id+'/do_today'
      patch: true
      success: (model) =>
       $("#issue-#{@issue.id}").closest('.media').hide(500, ->
          @.remove()
        )

  startWorkload: (e) ->
    @workload = new Timecard.Models.Workload
    @workload.save { start_at: new Date() },
      url: @issue.urlRoot + '/' + @issue.id + '/workloads/start'
      success: (model) ->
        issue = new Timecard.Models.Issue(model.get('issue'))
        @viewIssuesShow = new Timecard.Views.IssuesShow(issue: issue)
        $("#issue-#{issue.id}").closest('.media').replaceWith(@viewIssuesShow.render().el)

        if model.attributes.prev_issue?
          prev_issue = new Timecard.Models.Issue(model.get('prev_issue'))
          @viewIssuesShow = new Timecard.Views.IssuesShow(issue: prev_issue)
          $("#issue-#{prev_issue.id}").closest('.media').replaceWith(@viewIssuesShow.render().el)

        @workers = new Timecard.Collections.Workers()
        @workers.fetch
          success: (collection) ->
            @viewWorkersIndex = new Timecard.Views.WorkersIndex(collection: collection)
            @viewWorkersIndex.render().el
            Workload.start(new Date(model.get('start_at')))
    false

  stopWorkload: (e) ->
    e.preventDefault()
    e.stopPropagation()
    workload_id = $(e.target).data('workload-id')
    $.ajax
      url: '/workloads/' + workload_id + '/stop'
      data:
        JSON.stringify({ workload: { end_at: new Date() } })
      type: 'PATCH'
      dataType: 'json'
      contentType: 'application/json'
      success: (data, textStatus, jqXHR) ->
        issue = new Timecard.Models.Issue(data.issue)
        @viewIssuesShow = new Timecard.Views.IssuesShow(issue: issue)
        $("#issue-#{issue.id}").replaceWith(@viewIssuesShow.render().el)
