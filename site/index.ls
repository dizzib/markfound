Cp  = require \child_process
_   = require \lodash
P   = require \path
Cfg = require \./config

module.exports = (cb) ->
  base-paths = (cfg = Cfg.get!).basePaths
  names = ["-name '#n'" for n in cfg.names] * ' -o '
  excludes = ["-not -path '#p'" for p in cfg.excludes] * ' '

  result = []
  find!

  function find
    return cb null result unless base-path = base-paths[result.length]
    log.debug cmd = "find #base-path -type f \\( #names \\) #excludes"
    err, stdout, stderr <- Cp.exec cmd
    return cb err if err
    return new Error stderr if stderr.length
    log.debug files = [P.relative base-path, f for f in stdout / '\n' when f].sort!
    result.push base-path:base-path, files:files
    find!
