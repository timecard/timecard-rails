window.server ?= sinon.fakeServer.create()
server.respondWith(
  'GET',
  '/api/my/projects',
  [
    200,
    { 'Content-Type': 'application/json' },
    '''
    [
      {
        "id": 1,
        "name": "Sample Project",
        "description": "This is Sample Project",
        "is_public": true,
        "parent_id": 0,
        "status": 1,
        "open_issues_count": 10
      }
    ]
    '''
  ]
)
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
