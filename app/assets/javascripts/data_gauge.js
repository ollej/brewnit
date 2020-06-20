class DataGauge {
  constructor(cls) {
    this.gauges = {};
    this.cls = cls;
  }

  cfg($el) {
    const cfg = $el.data();
    cfg.yellowZones = [{ from: cfg.yellowFrom, to: cfg.yellowTo }];
    cfg.redZones = [{ from: cfg.redFrom, to: cfg.redTo }];
    return cfg;
  }

  setupGauge($el) {
    const id = $el.attr('id');
    const cfg = this.cfg($el);
    const gauge = new Gauge(id, cfg);
    gauge.render();
    if (cfg.value) {
      gauge.redraw(cfg.value);
    }
    this.gauges[id] = gauge;
  }

  init() {
    $(this.cls).each((idx, el) => this.setupGauge($(el)));
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).DataGauge = DataGauge;
