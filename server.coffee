url          = require('url')
path         = require('path')
connect      = require('connect')
connectRoute = require('connect-route')

DATA = [
  {id: 1, filter: false, name: 'One'},
  {id: 2, filter: true, name: 'Two'},
  {id: 3, filter: false, name: 'Three'},
  {id: 4, filter: true, name: 'Four'},
  {id: 5, filter: false, name: 'Five'},
  {id: 6, filter: true, name: 'Six'},
  {id: 7, filter: true, name: 'Seven'},
  {id: 8, filter: false, name: 'Eight'},
  {id: 9, filter: true, name: 'Nine'},
  {id: 10, filter: true, name: 'Ten'}
]

app = connect()

app.use(connect.logger('dev'))
app.use(connect.static(__dirname + '/assets'))

app.use(connectRoute (router) ->
  router.get '/api/tests', (req, res, next) ->
    reqUrl = url.parse(req.url, true)

    limit  = parseInt(reqUrl.query.limit, 10) || 5
    offset = parseInt(reqUrl.query.offset, 10) || 0

    data = switch reqUrl.query.filtered
      when 'filtered'   then DATA.filter (d) -> d.filter
      when 'unfiltered' then DATA.filter (d) -> !d.filter
      else DATA

    res.writeHead(200, 'Content-Type': 'application/json')
    res.end(JSON.stringify(data.slice(offset, offset + limit)))
)

app.listen(8080)
