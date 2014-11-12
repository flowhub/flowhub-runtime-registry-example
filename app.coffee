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
    id: "f1af0a91-ae1e-4404-abc9-2ab1ef46dc85"  # UUIDv4
    user: "b999a62a-b900-4133-911c-d26cc3620ae1" # Runtime owner string/UUIDv4
    secret: "changeme" # Secret string used for communicating with the runtime
    type: "noflo-nodejs"  # Runtime type, eg. noflo-browser, noflo-nodejs, microflo, imgflo
    protocol: "websocket"  # Protocol used, eg. webrtc, websocket
    address: "ws://localhost:" # URL to runtime
    label: "custom registry runtime" # Human-readable runtime label
    description: "a description" # Human-readable description for the runtime
    registered: (new Date()).toJSON() # (datetime) First registered.
    seen: (new Date()).toJSON() # (datetime) Last seen. NB: Flowhub only shows recently active runtimes
  }

]

# Runtime registry routes
# Each route will get the OAuth2 bearer token from Flowhub,
# which can be used for authentication and filtering data based on access level
runtimes = {}
runtimes.list = [
  (req, res) ->
    console.log 'runtimes.list'
    res.json runtimeStore
]

runtimes.get = [
  (req, res) ->
    id = req.params.id
    for runtime in runtimeStore
      if runtime.id is id
        return res.json runtime
]

app.get '/runtimes', runtimes.list
app.get '/runtimes/:id', runtimes.get

# Optional
###
app.put '/runtimes/:id', runtimes.register # runtimes call to insert themselves into DB
app.post '/runtimes/:id', runtimes.ping  # runtimes call to update their 'seen' datetime
app.get '/runtimes/events', runtimes.events # EventSource, used to provide change notifications to clients
app.del '/runtimes/:id', runtimes.del
###

# Safety catch-all
process.on 'uncaughtException', (e) ->
  console.log 'UNCAUGHT EXCEPTION', e

module.exports = app
