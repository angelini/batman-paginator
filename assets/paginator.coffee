Batman.Model::hasSearch = -> @_batman.get('search')?

Batman.Model.searchAdapter = (mechanism, options...) ->
    Batman.initializeObject @prototype
    mechanism = if mechanism.isSearchAdapter then mechanism else new mechanism(@)
    Batman.mixin mechanism, options... if options.length > 0
    @::_batman.search = mechanism
    mechanism

Batman.Model.search = (query, callback) ->
  Batman.developer.assert @::hasSearch(), "Can't search model #{Batman.functionName(@constructor)} without any search adapters!"
  engine = @::_batman.get('search')
  engine.perform(query, callback)

class Batman.SearchAdapter extends Batman.Object
  constructor: (@model) ->

  isSearchAdapter: true

  optionsFromQuery: (query) -> query.get('options')

  request: (options, callback) ->
    new Batman.Request({
      data: options
      url: @url
      success: (data) -> callback(null, data)
      error: (error) -> callback(error, null)
    })

  perform: (query, callback) ->
    @request(@optionsFromQuery(query), callback)

class Batman.Paginator extends Batman.Object
  constructor: (@modelClass, @options = {}) ->
    @options.limit  = @options.limit || 1
    @options.offset = @options.offset || 0

  first: (callback) ->
    @options.offset = 0
    @load(callback)

  next: (callback) ->
    @options.offset = @options.offset + @options.limit
    @load(callback)

  prev: (callback) ->
    @options.offset = Math.max(@options.offset - @options.limit, 0)
    @load(callback)

  generateQuery: ->
    new Batman.Query(@options)

  load: (callback) ->
    @modelClass.search(@generateQuery(), callback)

class Batman.FilteredPaginator extends Batman.Paginator
  constructor: (@modelClass, @filters = [], @options = {}) ->
    super(@modelClass, @options)

  generateQuery: ->
    query = super()
    @filters.forEach (filter) -> query.extend(filter.toQuery())
    query

class Batman.Filter extends Batman.Object
  constructor: (@display, @name, @options = {}, @default) ->
    @set('value', @default)

  @accessor 'displayValue', -> @options[@get('value')]

  toQuery: ->
    options = {}
    options[@name] = @get('value')
    return new Batman.Query(options)

class Batman.Query extends Batman.Object
  constructor: (@options = {}) ->

  extend: (query) ->
    @set('options', Batman.extend(@get('options'), query.get('options')))
