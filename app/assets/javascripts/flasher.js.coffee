class Flasher
  constructor: (@sel) ->
    @div().on('click', @clear)
    $("body").on("flasher:show", @handler)
      .on("flasher:clear", @clear)

  div: -> @$div ?= $(@sel)
  warning: (msg) -> @flash(msg, 'error')
  error: (msg) -> @flash(msg, 'error')
  info: (msg) -> @flash(msg, 'success')
  success: (msg) -> @flash(msg, 'success')
  clear: => @div().html('')
  handler: (ev, options) => @flash(options.message, options.level)

  scroll: ->
    $("html, body").animate({ scrollTop: 0 }, 500)
    @div().children().effect("highlight", {}, 750)

  flash: (msg, level = "error") ->
    @div().append("<div class='pure-alert pure-alert-#{level}'>#{msg}</div>")
    @scroll()


(exports ? this).Flasher = Flasher