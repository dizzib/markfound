Cp     = require \child_process
Fs     = require \fs
_      = require \lodash
Path   = require \path
Ws     = require \faye-websocket
Config = require \./config
Transf = require \./transform

module.exports = (http) ->
  http.on \upgrade (req, socket, body) ->
    return unless Ws.isWebSocket req
    ws = new Ws req, socket, body
    ws.on \message ->
      fpath = it.data.replace /^\/(\d)/ (m, bidx) -> Config.get!basePaths[bidx]
      err, fs-type, stderr <- Cp.exec "stat -fc%T #fpath"
      if err or stderr.length
        log err if err
        log stderr if stderr.length
        log 'unable to determine filesystem type -- fallback to use polling'
        use-polling = true
      else
        fs-type = fs-type.replace '\n' ''
        log "filesystem type is #fs-type"
        use-polling = fs-type in <[ cifs nfs sshfs vboxsf ]>
      # debounce is required since some editors write multiple times when saving
      refresh-client-debounced = _.debounce refresh-client, 100ms, leading:false trailing:true
      if use-polling
        Fs.watchFile fpath, interval:2000ms, refresh-client-debounced
        log.debug "watching #fpath using polling"
      else
        fsw = Fs.watch fpath, refresh-client-debounced
        log.debug "watching #fpath using inotify"
      ws.on \close ->
        log.debug "stop watching #fpath"
        if use-polling then Fs.unwatchFile fpath else fsw.close!
        ws = void
      refresh-client!
      function refresh-client
        log.debug 'refresh-client' fpath
        err, body <- Transf fpath
        return log err if err
        ws.send body
