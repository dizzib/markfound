# markfound
[![Build Status][travis-image]][travis-url]

Runs Linux [find] to build an index of local markdown files for live preview:

* configure the base path and file patterns to include/exclude
* styled for GitHub readme.md with option to add custom css
* live refresh

## install globally and run

    $ npm install -g markfound            # might need to prefix with sudo

    $ cd directory/containing/markdown/files
    $ markfound

then navigate to `http://localhost:4500` to see the index of markdown files.
Follow a link for a live preview.

## configure

On its first run markfound copies the [default configuration file] to
`$XDG_CONFIG_HOME/markfound.conf` which [defaults to][$XDG_CONFIG_HOME]
`$HOME/.config/markfound.conf`.
This is a [leanconf] file with the following settings:

* `basePath:` - (required) path to the directory containing the markdown files.
  Set to an absolute path to let markfound run from anywhere.
  Default is the current directory.

* `names` - (required) a list of one or more wildcard patterns of form `*.ext`
  where `ext` is the extension to include.
  Place each pattern on its own line indented to the same level.

* `excludes` - (optional) a list of exclusion patterns passed to the Linux
  [find] `-path` option.
  Place each path on its own line indented to the same level.

* `stylusPath:` - (optional) path to a [stylus] file containing custom styling.
  For example, to increase the spacing between index list items and add borders
  around code elements, create a file `markfound.styl` alongside `markfound.conf`
  with this content:

  ```stylus
  .index
    li
      margin 1em

  .markdown-body
    code
      border solid grey 1px
  ```

  and add setting `stylusPath: ./markfound.styl` to `markfound.conf`.

## options

    $ markfound --help
    Usage: markfound [Options]

    Options:

      -h, --help                output usage information
      -V, --version             output the version number
      -c, --config-path [path]  path to configuration file (default:~/.config/markfound.conf)
      -p, --port [port]         listening port (default:4500)
      -v, --verbose             emit detailed trace for debugging

## developer build and run

    $ git clone --branch=dev https://github.com/dizzib/markfound.git
    $ cd markfound
    $ npm install     # install dependencies
    $ npm test        # build all and run tests
    $ npm start       # start the task runner

## license

[MIT](./LICENSE)

[$XDG_CONFIG_HOME]: http://standards.freedesktop.org/basedir-spec/basedir-spec-latest.html
[default configuration file]: ./site/default.conf
[find]: http://man7.org/linux/man-pages/man1/find.1.html
[leanconf]: https://github.com/dizzib/leanconf
[stylus]: https://learnboost.github.io/stylus
[travis-image]: https://travis-ci.org/dizzib/markfound.svg?branch=master
[travis-url]: https://travis-ci.org/dizzib/markfound
