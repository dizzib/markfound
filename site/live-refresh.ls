_      = require \lodash
Fs     = require \fs
Path   = require \path
Ws     = require \faye-websocket
Config = require \./config
Transf = require \./transform

module.exports = (http) ->
  http.on \upgrade (req, socket, body) ->
    return unless Ws.isWebSocket req
    ws = new Ws req, socket, body
    ws.on \message ->
      function refresh-client e
        log.debug 'refresh-client' e, fpath
        err, body <- Transf fpath
        return log err if err
        ws.send body
      fpath = it.data.replace /^\/(\d)/ (m, bidx) -> Config.get!basePaths[bidx]
      # debounce is required since some editors write multiple times when saving
      Fs.watch fpath, _.debounce refresh-client, 100ms, leading:false trailing:true
      refresh-client \init
    ws.on \close ->
      log.debug 'close'
      ws = void
