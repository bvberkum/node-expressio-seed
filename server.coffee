port = 7001

express = require 'express'
app = require('express.io')()
app.http().io()


# Setup the ready route, and emit talk event.
app.io.route 'ready', (req) ->
  req.io.emit 'talk',
    message: 'io event from an io route on the server'

# add static files
app.use express.static 'public'

# set the root resource
app.get '/', (req, res) ->
  res.redirect 'client.html'

# export this module
module.exports =
  port: port
  app: app
  proc: null
  run: ( done ) ->
    console.log "Starting server"
    proc = app.listen port, ->
      console.log "server at localhost:#{port}"
      !done || done()
    module.exports.proc = proc
    proc

# start server if this script was invoked by coffee directly
if process.argv.join(' ') == 'coffee '+require.resolve './server'
  module.exports.run()


