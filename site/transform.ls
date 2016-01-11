Fs   = require \fs
M    = require \marked
Path = require \path
Cfg  = require \./config

module.exports = (fpath, cb) ->
  err, md <- Fs.readFile fpath, encoding:\utf8
  return cb err if err
  cb null body = M md
