Fs   = require \fs
Lc   = require \leanconf
_    = require \lodash
Args = require \./args

var cfg, fsw

module.exports = me =
  get : -> cfg
  load: ->
    function reload ev
      return unless ev is \change
      log "Reload #path"
      me.load!
    me.reset!
    path = Args.config-path
    try
      log.debug "load config from #path"
      conf = Fs.readFileSync path
    catch e
      return throw e unless e.code is \ENOENT
      log "Unable to find configuration file #path"
      unless Args.is-default-config-path
        log 'Please ensure this path is correct and the file exists.'
        return me
      log "Copying default config to #path"
      Fs.writeFileSync path, conf = Fs.readFileSync "#__dirname/default.conf"
    cfg := Lc.parse conf
    validate!
    fsw := Fs.watch path, _.debounce reload, 500ms, leading:false trailing:true
    me
  reset: -> # for tests
    fsw?close!
    cfg := null

function validate
  throw new Error 'basePath not found' unless cfg.basePath?length
  throw new Error 'names not found' unless _.isArray cfg.names and cfg.names.length
  bad-keys =_.without (_.keys cfg), \basePath \names \excludes \stylusPath
  return unless bad-keys.length
  throw new Error "unrecognised keys #bad-keys"
