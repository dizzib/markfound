Fs   = require \fs
M    = require \marked
Path = require \path
Args = require \./args

module.exports = (path, cb) ->
  full-path = Path.join Args.root-path, path
  log.debug full-path
  err, md <- Fs.readFile full-path, encoding:\utf8
  return cb err if err
  cb null body = M md
