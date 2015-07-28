test = it
<- describe 'config'

A = require \chai .assert
S = require \shelljs/global
M = require \mockery

var args, T
deq = A.deepEqual

after ->
  M.deregisterAll!
  M.disable!
before ->
  M.enable warnOnUnregistered:false
  M.registerMock \./args args := config-path:\/tmp/markfound.conf
  T := require \../site/config
beforeEach ->
  T.reset!

function expect then deq T.load!get!, it
function prepare then cp \-f "./test/config/#it.conf" args.config-path
function run id, exp then prepare id; expect exp

const MIN = basePath:\/bp names:<[*.a]>
const MAX = basePath:\/bp names:<[*.a *.b]> excludes:<[* *]> stylusPath:\/sp

describe 'missing' ->
  beforeEach -> rm \-f args.config-path
  test 'with default config-path should copy default.conf' ->
    args.is-default-config-path = true
    expect basePath:\./ names:<[*.md *.markdown]> excludes:<[*/node_modules/* */tmp/* */temp/*]>
  test 'with overridden config-path' ->
    args.is-default-config-path = false
    T.load!; A.isNull T.get!

test 'min' -> run \min MIN
test 'max' -> run \max MAX

test 'updated file should auto-reload' (done) ->
  run \min MIN
  prepare \max
  setTimeout (-> expect MAX; done!), 5

describe 'error' ->
  function run id, expect then prepare id; A.throws T.load, expect
  test 'no-basepath' -> run \no-basepath 'basePath not found'
  test 'no-names'    -> run \no-names 'names not found'
  test 'bad-keys'    -> run \bad-keys 'unrecognised keys foo,bar'
