express = require 'express'

app = express()
app.use express.logger()
app.use express.urlencoded()
app.use express.json()
app.use app.router


# Allow CORS so Flowhub apps can talk to the API
app.all '/*', (req, res, next) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Methods', 'GET, PUT, POST, OPTIONS'
  res.header 'Access-Control-Allow-Headers', 'Content-Type, Authorization'
  next()

# Runtime registry storage
# Would typically be a database or query another service
runtimeStore = [
  {
    id:   # UUID
    user: # Runtime owner string/UUID
    secret:  # Secret string used for communicating with the runtime
    address:  # URL to runtime
    protocol:   # Protocol used, eg. webrtc, websocket
    type:  # Runtime type, eg. noflo-browser, noflo-nodejs, microflo, imgflo
    label: # Human-readable runtime label
    description:             # Human-readable description for the runtime
    registered: # (datetime) First registered.
    seen: # (datetime) Last seen. 
  }

]

# Runtime registry routes
runtimes = {}
runtimes.list = [
  (req, res) ->
    db('runtimes')
    .select()
    .where('user', req.user.id)
    .then (rows) ->
      res.json rows
    .otherwise (e) ->
      res.send 500
]

runtimes.get = [
  (req, res) ->
    db 'runtimes'
    .select()
    .where(
      id: req.params.id
      user: req.user.id
    )
    .then (rows) ->
      unless rows.length
        return res.send 404
      res.json rows[0]
    .otherwise (e) ->
      res.send 500
]

app.get '/runtimes', runtimes.list
app.get '/runtimes/:id', runtimes.get

# Optional
app.put '/runtimes/:id', runtimes.register
app.post '/runtimes/:id', runtimes.ping
app.del '/runtimes/:id', runtimes.del
app.get '/runtimes/events', runtimes.events

# Safety catch-all
process.on 'uncaughtException', (e) ->
  console.log 'UNCAUGHT EXCEPTION', e

module.exports = app
