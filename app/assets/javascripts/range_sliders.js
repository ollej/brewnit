class RangeSliders {
  constructor(cls) {
    this.sliders = {};
    this.config = {
      connect: true,
      direction: 'ltr',
      orientation: 'horizontal',
      behaviour: 'tap-drag',
    };
    this.formatSG = {
      from(val) { return (val != null ? val.toString() : undefined); },
      to(val) { return (val != null ? val.toFixed(3) : undefined); }
    };
    this.formatNumber = {
      from(val) { return (val != null ? val.toString() : undefined); },
      to(val) { return (val != null ? val.toFixed(0) : undefined); }
    };
    this.setupSlider = this.setupSlider.bind(this);
    this.cls = cls;
  }

  init() {
    $(this.cls).each(this.setupSlider);
    return this;
  }

  options($el) {
    const id = $el.attr('id');
    const min = parseFloat($el.data("rangeMin"));
    const max = parseFloat($el.data("rangeMax"));
    const from = parseFloat($(`.${id}-from`).val()) || min;
    const to = parseFloat($(`.${id}-to`).val()) || max;
    const step = parseFloat($el.data("rangeStep"));
    const margin = parseFloat($el.data("rangeMargin"));
    const formatter = this[$el.data("rangeFormatter")];
    return $.extend({}, this.config, {
      start: [from, to],
      range: {
        min,
        max
      },
      step,
      margin,
      tooltips: [ formatter, formatter ],
      format: formatter,
      pips: {
        mode: 'steps',
        density: 2,
        format: formatter
      }
    });
  }

  setupSlider(idx, el) {
    const $el = $(el);
    const id = $el.attr('id');
    this.sliders[id] = el;
    noUiSlider.create(el, this.options($el));
    el.noUiSlider.on('set', function(values, handle, unencoded, tap) {
      if (handle) {
        $(`.${id}-to`).val(values[handle]);
      } else {
        $(`.${id}-from`).val(values[handle]);
      }
    });
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).RangeSliders = RangeSliders;
