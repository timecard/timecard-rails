#= require spec_helper

describe 'Timecard.Views.HomeMain', ->
  beforeEach ->
    @page.html("<div class='contents'></div>")
    @issues = new Timecard.Collections.Issues()
    @workloads = new Timecard.Collections.Workloads()
    @view = new Timecard.Views.HomeMain(issues: @issues, workloads: @workloads)
    @page.html(@view.render().el)
    server.respond()

  it 'contains element of .projects-show', ->
    expect($('.projects-show').length).to.equal(1)

  it 'contains element of .issues-index', ->
    expect($('.issues-index').length).to.equal(1)
