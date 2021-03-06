Assert  = require \assert
Choki   = require \chokidar
Cron    = require \cron
Emitter = require \events .EventEmitter
Fs      = require \fs
_       = require \lodash
Path    = require \path
Shell   = require \shelljs/global
WFib    = require \wait.for .launchFiber
W4      = require \wait.for .for
W4m     = require \wait.for .forMethod
Dir     = require \./constants .dir
Dirname = require \./constants .dirname
G       = require \./growl

pruner = new Cron.CronJob cronTime:'*/10 * * * *' onTick:prune-empty-dirs
tasks  =
  livescript:
    cmd   : "#{Dir.ROOT}/node_modules/.bin/lsc --output $OUT $IN"
    ixt   : \ls
    oxt   : \js
    xsub  : 'json.js->json'
  static:
    cmd : 'cp --target-directory $OUT $IN'
    pat : '{markfound,*.{conf,jade,js,md,png}}'

module.exports = me = (new Emitter!) with
  all: ->
    for tid of tasks then compile-batch tid
    me.emit \built

  delete-files: ->
    log "delete #{Dir.BUILD}"
    rm \-rf Dir.BUILD

  start: ->
    G.say 'build started'
    try
      pushd Dir.ROOT
      for tid of tasks then start-watching tid
    finally
      popd!
    pruner.start!

  stop: ->
    pruner.stop!
    for , t of tasks then t.watcher?close!
    G.say 'build stopped'

## helpers

function compile t, ipath, cb
  Assert.equal pwd!, Dir.BUILD
  ipath-abs = Path.resolve Dir.ROOT, ipath
  mkdir \-p odir = Path.dirname opath = get-opath t, ipath
  switch typeof t.cmd
  | \string =>
    cmd = t.cmd.replace(\$IN "'#ipath-abs'").replace \$OUT "'#odir'"
    G.say cmd
    code, res <- exec cmd
    log code, res if code
    cb (if code then res else void), opath
  | \function =>
    e <- t.cmd ipath-abs, opath
    cb e, opath

function compile-batch tid
  t = tasks[tid]
  w = t.watcher._watched
  # https://github.com/paulmillr/chokidar/issues/281
  files = [ p-abs for p, v of w for f of v._items
    when test \-f p-abs = Path.join p, f ]
  info = "#{files.length} #tid files"
  G.say "compiling #info..."
  for f in files then W4 compile, t, Path.relative Dir.ROOT, f
  G.ok "...done #info!"

function get-opath t, ipath
  p = ipath.replace t.ixt, t.oxt if t.ixt?
  return p or ipath unless (xsub = t.xsub?split '->')?
  p.replace xsub.0, xsub.1

function prune-empty-dirs
  unless pwd! is Dir.BUILD then return log 'bypass prune-empty-dirs'
  code, out <- exec "find . -type d -empty -delete"
  G.err "prune failed: #code #out" if code

function start-watching tid
  log "start watching #tid"
  Assert.equal pwd!, Dir.ROOT
  pat = (t = tasks[tid]).pat or "*.#{t.ixt}"
  w = t.watcher = Choki.watch "**/#pat",
    cwd: Dir.ROOT
    ignoreInitial: true
    ignored: <[ _build node_modules ]>
    persistent: false
  w.on \all _.debounce process, 500ms, leading:true trailing:false

  function process act, ipath
    log act, tid, ipath
    switch act
    | \add \change
      err, opath <- compile t, ipath
      return G.err err if err
      G.ok opath
      me.emit \built
    | \unlink
      Assert.equal pwd!, Dir.BUILD
      err <- Fs.unlink opath = get-opath t, ipath
      return G.err err unless err.code is \ENOENT # not found i.e. already deleted
      G.ok "Delete #opath"
      me.emit \built
