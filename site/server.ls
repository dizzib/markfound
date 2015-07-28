global.log = console.log
global.log.debug = if (Args = require \./args).verbose then console.log else ->

ErrHan  = require \errorhandler
Express = require \express
Http    = require \http
Morgan  = require \morgan if is-dev = (env = process.env.NODE_ENV) in <[ development ]>
Path    = require \path
Config  = require \./config .load!get! # must load before following requires
CustCss = require \./custom-css
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
for na in Config.names then express.get na, (req, res, next) ->
  err, body <- Transf req.originalUrl
  return next err if err
  err, css <- CustCss
  return next err if err
  res.render \template/github body:body, css:css
express
  ..use Express.static "#__dirname/client"
  #..use Express.static Config.base-path
  ..use ErrHan log: -> log it.stack

LiveRef http = Http.createServer express
http.listen (port = Args.port), (err) ->
  return log err if err
  log "Express http server listening on port #port"
