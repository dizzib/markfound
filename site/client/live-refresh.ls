# set global log fn. We can't just set window.log = console.log because we'll get
# 'illegal invocation' errors, since console.log expects 'this' to be console.
log = -> console.log ...&

ws = new WebSocket "ws://#{location.host}"
  ..onmessage = ->
    # rather annoyingly location.reload causes window chrome to appear,
    # therefore we inject the updated HTML directly into the Dom.
    $ \.markdown-body .html it.data
  ..onopen = ->
    ws.send location.pathname
