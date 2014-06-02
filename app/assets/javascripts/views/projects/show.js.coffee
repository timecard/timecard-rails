class Timecard.Views.ProjectsShow extends Backbone.View

  template: JST['projects/show']

  el: '.contents'

  initialize: ->
    @issues = new Timecard.Collections.Issues

  render: ->
    @$el.html(@template())
    @viewProjectsDetail = new Timecard.Views.ProjectsDetail(model: @model)
    @viewProjectsDetail.render()
    @issues.fetch
      data:
        project_id: @model.id
      success: (collection) ->
        @viewIssuesList = new Timecard.Views.IssuesList(collection: collection)
        @viewIssuesList.render()
    @
