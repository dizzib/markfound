global.log = console.log

is-dev = (env = process.env.NODE_ENV) in <[ development ]>

ErrHan  = require \errorhandler
Express = require \express
Fs      = require \fs
Http    = require \http
Morgan  = require \morgan if is-dev
Path    = require \path
Shell   = require \shelljs/global
Args    = require \./args

express = Express!
  ..set \port, Args.port
  ..use Morgan \dev if is-dev
  #..use Express.static
  ..use ErrHan log: -> log it.stack

http = Http.createServer express
err <- http.listen port = Args.port
return log err if err
log "Express http server listening on port #port"
