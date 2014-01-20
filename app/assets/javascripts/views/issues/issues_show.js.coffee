class Timecard.Views.IssuesShow extends Backbone.View

  template: JST['issues/show']

  events:
    'click .js-close-issue-button': 'closeIssue'
    'click .js-reopen-issue-button': 'reopenIssue'
    'click .js-postpone-issue-button': 'postponeIssue'
    'click .js-do-today-issue-button': 'doTodayIssue'
    'click .js-start-workload-button': 'startWorkload'
    'click .js-stop-workload-button': 'stopWorkload'
    'click .js-stop-workload-password-button': 'stopWorkloadAndPassword'

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
    e.preventDefault()
    e.stopPropagation()
    $.ajax
      url: '/issues/' + @issue.id + '/workloads/start'
      type: 'POST'
      dataType: 'json'
      contentType: 'application/json'
      success: (data, textStatus, jqXHR) ->
        issue = new Timecard.Models.Issue(data.issue)
        @viewIssuesShow = new Timecard.Views.IssuesShow(issue: issue)
        $("#issue-#{issue.id}").replaceWith(@viewIssuesShow.render().el)
        unless prev_issue?
          prev_issue = new Timecard.Models.Issue(data.prev_issue)
          @viewIssuesShow = new Timecard.Views.IssuesShow(issue: prev_issue)
          $("#issue-#{prev_issue.id}").replaceWith(@viewIssuesShow.render().el)

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

  stopWorkloadAndPassword: (e) ->
    e.preventDefault()
    e.stopPropagation()
    pass = window.prompt("password?\n***It does not save the password.***", "")
    if (pass)
      workload_id = $(e.target).data('workload-id')
      $.ajax
        url: '/workloads/' + workload_id + '/stop'
        data:
          JSON.stringify({ workload: { end_at: new Date() }, password: pass })
        type: 'PATCH'
        dataType: 'json'
        contentType: 'application/json'
        success: (data, textStatus, jqXHR) ->
          issue = new Timecard.Models.Issue(data.issue)
          @viewIssuesShow = new Timecard.Views.IssuesShow(issue: issue)
          $("#issue-#{issue.id}").replaceWith(@viewIssuesShow.render().el)

