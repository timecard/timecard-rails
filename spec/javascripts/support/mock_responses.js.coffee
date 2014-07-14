window.server ?= sinon.fakeServer.create()
server.respondWith(
  'GET',
  '/api/my/issues',
  [
    200,
    { 'Content-Type': 'application/json' },
    '''
    []
    '''
  ]
)
