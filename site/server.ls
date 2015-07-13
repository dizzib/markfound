global.log = console.log
Args = require \./args
global.log.debug = if Args.verbose then console.log else ->

ErrHan  = require \errorhandler
Express = require \express
Http    = require \http
Morgan  = require \morgan if is-dev = (env = process.env.NODE_ENV) in <[ development ]>
Index   = require \./index
Transf  = require \./transform

express = Express!
  ..set \port Args.port
  ..use Morgan \dev if is-dev
  ..set 'view engine' \jade
  ..set \views __dirname
  ..get '/' (, res, next) ->
    err, paths <- Index
    return next err if err
    res.render \index paths:paths
  ..get '/*/*.md' (req, res, next) ->
    err, body <- Transf req.originalUrl
    return next err if err
    res.render \template/github body:body
  ..use Express.static Args.root-path
  ..use ErrHan log: -> log it.stack

http = Http.createServer express
err <- http.listen port = Args.port
return log err if err
log "Express http server listening on port #port"
