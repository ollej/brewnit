class RangeSliders
  sliders: {}
  config: {
    connect: true,
    direction: 'ltr',
    orientation: 'horizontal',
    behaviour: 'tap-drag',
  }

  formatSG: {
    from: (val) -> val?.toString(),
    to: (val) -> val?.toFixed(3)
  }

  constructor: (@cls) ->

  options: ($el) ->
    id = $el.attr('id')
    min = parseFloat($el.data("rangeMin"))
    max = parseFloat($el.data("rangeMax"))
    from = parseFloat($(".#{id}-from").val()) || min
    to = parseFloat($(".#{id}-to").val()) || max
    step = parseFloat($el.data("rangeStep"))
    margin = parseFloat($el.data("rangeMargin"))
    formatter = this[$el.data("rangeFormatter")]
    return $.extend({}, @config, {
      start: [from, to],
      range: {
        min: min,
        max: max
      },
      step: step,
      margin: margin,
      tooltips: [ formatter, formatter ],
      format: formatter,
      pips: {
        mode: 'steps',
        density: 2,
        format: formatter
      }
    })

  setupSlider: (idx, el) =>
    @sliders[id] = el
    $el = $(el)
    id = $el.attr('id')
    noUiSlider.create(el, @options($el))
    el.noUiSlider.on('set', (values, handle, unencoded, tap) ->
      if handle
        $(".#{id}-to").val(values[handle])
      else
        $(".#{id}-from").val(values[handle])
    )

  init: ->
    $(@cls).each(@setupSlider)

(exports ? this).RangeSliders = RangeSliders
