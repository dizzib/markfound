Fs   = require \fs
Path = require \path
Styl = require \stylus
Args = require \./args
Cfg  = require \./config

module.exports = (cb) ->
  return cb! unless stylus-path = Cfg.get!stylusPath
  config-path = Path.dirname Args.config-path
  path = Path.resolve config-path, stylus-path
  log.debug "read custom stylus from #path"
  err, stylus <- Fs.readFile path, encoding:\utf8
  return cb err if err
  Styl.render stylus, cb
