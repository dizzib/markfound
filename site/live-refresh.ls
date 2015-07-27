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
      fname = Path.join Config.get!base-path, path = it.data
      # debounce is required since some editors write multiple times when saving
      Fs.watch fname, _.debounce refresh-client, 100ms, leading:false trailing:true
      function refresh-client e
        log.debug 'refresh-client' e, fname
        err, body <- Transf path
        return log err if err
        ws.send body
    ws.on \close ->
      log.debug 'close'
      ws = void
