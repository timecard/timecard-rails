class Timecard.Views.WorkersShow extends Backbone.View

  template: JST['workers/show']

  tagName: 'tr'

  events:
    'click .js-stop-workload-button': 'stopWorkload'

  className: 'worker'

  initialize: (@options) ->
    @project = new Timecard.Models.Project(@model.get('project'))
    @issue = new Timecard.Models.Issue(@model.get('issue'))
    @workload = new Timecard.Models.Workload(@model.get('workload'))

  render: ->
    @$el.html(@template(
      worker: @model,
      project: @project,
      issue: @issue,
      workload: @workload))
    @

  stopWorkload: (e) ->
    @workload.save { end_at: new Date },
      url: @workload.urlRoot + '/' + @workload.get('id') + '/stop'
      patch: true
      success: (model) =>
        issue = new Timecard.Models.Issue(model.get('issue'))
        $("#worker-#{model.get('user_id')}").hide 500, ->
          $(@).remove()
        @viewIssuesShow = new Timecard.Views.IssuesShow(issue: issue)
        $("#issue-#{@issue.get('id')}").closest('.media').html(@viewIssuesShow.render().el)
    false

    Workload.stop()
    false
