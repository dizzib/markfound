global.log = console.log
global.log.debug = if (Args = require \./args).verbose then console.log else ->

ErrHan  = require \errorhandler
Express = require \express
Http    = require \http
Morgan  = require \morgan if is-dev = (env = process.env.NODE_ENV) in <[ development ]>
Path    = require \path
Config  = require \./config .load! # must load first
LiveRef = require \./live-refresh
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
  ..get /.*\.(markdown|md)$/ (req, res, next) ->
    err, body <- Transf req.originalUrl
    return next err if err
    res.render \template/github body:body
  ..use Express.static "#__dirname/client"
  #..use Express.static Config.base-path
  ..use ErrHan log: -> log it.stack

LiveRef http = Http.createServer express
err <- http.listen port = Args.port
return log err if err
log "Express http server listening on port #port"
