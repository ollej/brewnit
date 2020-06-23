class BeerPie {
  constructor(el, tab, data) {
    this.drawn = false;
    this.el = el;
    this.tab = tab;
    this.data = data;
    this.d3 = new d3pie(this.el, this.config());
    $("body").on("tab-changed", this.draw.bind(this));
  }

  draw(ev, id) {
    if (id !== this.tab) { return; }
    if (this.drawn) { return; }
    this.d3.redraw();
    this.drawn = true;
  }

  config() {
    return {
      "footer": {
        "color": "#999999",
        "fontSize": 11,
        "font": "Montserrat",
        "location": "bottom-center"
      },
      "size": {
        "canvasHeight": 320,
        "canvasWidth": 590,
        "pieOuterRadius": "90%"
      },
      "data": {
        "sortOrder": "value-desc",
        "content": this.data
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
          "font": "Montserrat",
          "fontSize": 13,
          "lineHeight": 1,
          "padding": 12,
          "backgroundOpacity": 0.8,
          "color": "#fff",
          "borderRadius": 2,
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
    };
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).BeerPie = BeerPie;
