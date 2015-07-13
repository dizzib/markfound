Cp   = require \child_process
_    = require \lodash
Args = require \./args

module.exports = (cb) ->
  exclude = ["-not -path '#p'" for p in <[ */_build/* */node_modules/* */tmp/* */temp/* ]>] * ' '
  cmd = "find #{root = Args.root-path} -name *.md #exclude"
  log.debug cmd
  err, stdout, stderr <- Cp.exec cmd
  return cb err if err
  return new Error stderr if stderr.length
  paths = [p.replace "#root/" '' for p in _.trimRight(stdout, '\n') / '\n']
  log.debug paths
  cb null paths
