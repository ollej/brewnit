class MediaTools
  constructor: (@thumbnail, @btnsel, @slider) ->
    @$slider = $(@slider)

  init: ->
    @$slider.on("mouseenter", @thumbnail, @hoverOver)
    @$slider.on("mouseleave", @thumbnail, @hoverOut)
    @$slider.on("ajax:success", ".destroy-button", @removeMedium)
    $(".fancybox").fancybox({
      openEffect: "elastic",
      closeEffect: "fade",
      preload: 3
    })

  removeMedium: (ev) =>
    #console.log(ev.target, $(ev.target).parents(@thumbnail))
    $(ev.target).parents(@thumbnail).remove()
    @$slider.trigger("media:update")

  hoverOver: (ev) =>
    $medium = $(ev.currentTarget)
    $btn = @button($medium)
    #console.log('hoverOver', $medium, $btn)
    $btn.show().position({
      my: "right top",
      at: "right-4 top+4",
      of: $medium.find("img")
    })

  hoverOut: (ev) =>
    $medium = $(ev.currentTarget)
    @button($medium).hide()

  button: ($medium) ->
    $medium.find(@btnsel)

(exports ? this).MediaTools = MediaTools

