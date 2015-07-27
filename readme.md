# markfound

Runs Linux [find] to build an index of local markdown files for live preview:

* configure the base path and file patterns to include/exclude
* styled for GitHub readme.md with option to add custom css
* live refresh

## install globally and run

    $ npm install -g markfound            # might need to prefix with sudo
    $ markfound

## configure

On its first run markfound copies the [default configuration file] to
`$XDG_CONFIG_HOME/markfound.conf` which [defaults to][$XDG_CONFIG_HOME]
`$HOME/.config/markfound.conf`.

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
[find]: http://linux.die.net/man/1/find
