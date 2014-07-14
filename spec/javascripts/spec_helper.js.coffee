#= require application
#= require chai-jquery
#= require sinon
#= require support/mock_responses


beforeEach ->
  @page = $('#konacha')
  @sandbox = sinon.sandbox.create()

afterEach ->
  @sandbox.restore()
