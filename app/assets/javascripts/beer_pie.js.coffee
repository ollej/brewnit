class BeerPie
  drawn: false

  constructor: (@el, @tab, @data) ->
    @d3 = new d3pie(@el, @config())
    $("body").on("redraw-d3", @draw)

  draw: (ev, id) =>
    return unless id == @tab
    return if @drawn
    @d3.redraw()
    @drawn = true

  config: ->
    {
      "header": {
        "title": {
          "text": "Malt",
          "fontSize": 22,
          "font": "Montserrat"
        },
        "subtitle": {
          "text": "",
          "color": "#999999",
          "fontSize": 10,
          "font": "Montserrat"
        },
        "titleSubtitlePadding": 12
      },
      "footer": {
        "color": "#999999",
        "fontSize": 11,
        "font": "Montserrat",
        "location": "bottom-center"
      },
      "size": {
        "canvasHeight": 400,
        "canvasWidth": 590,
        "pieOuterRadius": "90%"
      },
      "data": {
        "sortOrder": "value-desc",
        "content": @data
      },
      "labels": {
        "outer": {
          "pieDistance": 32
        },
        "inner": {
          "hideWhenLessThanPercentage": 3
        },
        "mainLabel": {
          "font": "Montserrat"
        },
        "percentage": {
          "color": "#e1e1e1",
          "font": "Montserrat",
          "decimalPlaces": 0
        },
        "value": {
          "color": "#e1e1e1",
          "font": "Montserrat"
        },
        "lines": {
          "enabled": true,
          "color": "#cccccc"
        },
        "truncation": {
          "enabled": true
        }
      },
      "tooltips": {
        "enabled": true,
        "type": "placeholder",
        "string": "{label}: {value} kg, {percentage}%",
        "styles": {
          "font": "Montserrat"
        }
      },
      "effects": {
        "pullOutSegmentOnClick": {
          "effect": "elastic",
          "speed": 400,
          "size": 8
        }
      },
      "misc": {
        "gradient": {
          "enabled": true,
          "percentage": 75,
          "color": "#15160e"
        }
      },
      "callbacks": {}
    }
  
(exports ? this).BeerPie = BeerPie
