Fs   = require \fs
M    = require \marked
Path = require \path
Cfg  = require \./config

module.exports = (path, cb) ->
  cfg = Cfg.get!
  full-path = Path.join cfg.basePath, path
  err, md <- Fs.readFile full-path, encoding:\utf8
  return cb err if err
  cb null body = M md
