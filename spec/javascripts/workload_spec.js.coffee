#= require spec_helper

describe 'Workload', ->
  it 'inserts to window object myself', ->
    expect(window).to.have.ownProperty('Workload')
