C = require \commander
P = require \path
J = require \./package.json

const DEFAULT-PORT = 4500

default-config-home = process.env.XDG_CONFIG_HOME or P.join process.env.HOME, \.config
default-config-path = "#default-config-home/markfound.conf"

C.version J.version
C.usage '[Options]'
C.option '-c, --config-path [path]' "path to configuration file (default:#default-config-path)" default-config-path
C.option '-p, --port [port]' "listening port (default:#DEFAULT-PORT)", DEFAULT-PORT
C.option '-v, --verbose' 'emit detailed trace for debugging'
C.parse process.argv
C.is-default-config-path = C.config-path is default-config-path

module.exports = C
