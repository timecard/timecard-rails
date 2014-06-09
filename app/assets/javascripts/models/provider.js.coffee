class Timecard.Models.Provider extends Backbone.Model

  defaults:
    id: null
    name: ''
    number: ''
    url: ''

  initialize: (attrs, options) ->
    @set('number', attrs.info.number)
    @set('url', attrs.info.html_url)
