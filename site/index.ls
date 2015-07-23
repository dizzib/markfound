Cp   = require \child_process
_    = require \lodash
Cfg  = require \./config

module.exports = (cb) ->
  base-path = (cfg = Cfg.get!).basePath
  names = ["-name '#n'" for n in cfg.names] * ' -o '
  excludes = ["-not -path '#p'" for p in cfg.excludes] * ' '
  cmd = "find #base-path -type f \\( #names \\) #excludes"
  log.debug cmd
  err, stdout, stderr <- Cp.exec cmd
  return cb err if err
  return new Error stderr if stderr.length
  paths = [p.replace "#base-path/" '' for p in _.trimRight(stdout, '\n') / '\n'].sort!
  log.debug paths
  cb null paths
