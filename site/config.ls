Fs   = require \fs
Lc   = require \leanconf
Sh   = require \shelljs/global
Args = require \./args

var cfg, fsw

module.exports = me =
  get : -> cfg
  load: ->
    me.reset!
    unless test \-e path = Args.config-path
      log "Unable to find configuration file #path"
      unless Args.is-default-config-path
        log 'Please ensure this path is correct and the file exists.'
        return me
      log "Copying default config to #path"
      cp "#__dirname/default.conf" path
    log.debug "load config from #path"
    log cfg := Lc.parse Fs.readFileSync path
    fsw := Fs.watch path, (ev, fname) ->
      return unless ev is \change
      log "Reload #path"
      me.load!
    me
  reset: -> # for tests
    fsw?close!
    cfg := null
