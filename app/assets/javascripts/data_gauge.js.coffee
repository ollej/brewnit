class DataGauge
  gauges: {}

  constructor: (@cls) ->

  cfg: ($el) ->
    cfg = $el.data()
    cfg.yellowZones = [{ from: cfg.yellowFrom, to: cfg.yellowTo }]
    cfg.redZones = [{ from: cfg.redFrom, to: cfg.redTo }]
    return cfg

  setupGauge: ($el) ->
    id = $el.attr('id')
    cfg = @cfg($el)
    gauge = new Gauge(id, cfg)
    gauge.render()
    gauge.redraw(cfg.value) if cfg.value?
    @gauges[id] = gauge

  init: ->
    $(@cls).each((idx, el) => @setupGauge($(el)))

(exports ? this).DataGauge = DataGauge
