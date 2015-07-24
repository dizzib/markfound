Cp   = require \child_process
Cfg  = require \./config

module.exports = (cb) ->
  base-path = (cfg = Cfg.get!).basePath
  names = ["-name '#n'" for n in cfg.names] * ' -o '
  excludes = ["-not -path '#p'" for p in cfg.excludes] * ' '
  log.debug cmd = "find #base-path -type f \\( #names \\) #excludes"
  err, stdout, stderr <- Cp.exec cmd
  return cb err if err
  return new Error stderr if stderr.length
  log.debug paths = [p.replace "#base-path/" '' for p in stdout / '\n' when p].sort!
  cb null paths
