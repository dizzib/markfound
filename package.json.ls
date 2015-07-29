name       : \markfound
version    : \0.1.0
description: "Index a nested directory of markdown files for live preview"
keywords   : <[ exclude find github include index live markdown refresh nested reload ]>
homepage   : \https://github.com/dizzib/markfound
bugs       : \https://github.com/dizzib/markfound/issues
license:   : \MIT
author     : \dizzib
bin        : \./bin/markfound
repository :
  type: \git
  url : \https://github.com/dizzib/markfound
engines:
  node: '>=0.10.x'
  npm : '>=1.0.x'
scripts:
  start: './task/bootstrap && node ./_build/task/repl'
  test : './task/bootstrap && node ./_build/task/npm-test'
dependencies:
  commander       : \2.6.0
  errorhandler    : \1.3.2
  express         : \4.11.1
  'faye-websocket': \0.10.0
  jade            : \1.9.2
  leanconf        : \0.1.0
  lodash          : \3.5.0
  marked          : \0.3.3
  stylus          : \0.49.3
devDependencies:
  chai                 : \~3.0.0
  chalk                : \~0.4.0
  chokidar             : \~1.0.1
  cron                 : \~1.0.3
  'github-markdown-css': \~2.0.9
  growly               : \~1.2.0
  istanbul             : \~0.3.13
  livescript           : \~1.4.0
  mocha                : \~2.2.5
  mockery              : \~1.4.0
  morgan               : \~1.5.1
  shelljs              : \~0.3.0
  'wait.for'           : \~0.6.6
preferGlobal: true
