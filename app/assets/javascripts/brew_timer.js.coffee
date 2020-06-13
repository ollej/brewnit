class BrewTimer
  interval_time: 250
  increment: 1000
  # TODO: Configuration
  # TODO: Listen to start/stop events
  # TODO: Send start/stop/interval events
  # TODO: Render step list
  # TODO: Find current step in list

  constructor: (@el, @steps) ->
    console.log "steps: ", @steps
    @reset()
    @render()

  start: ->
    console.log('start')
    if @start_time?
      @start_time = Date.now() - @timer
    else
      @start_time = Date.now()
    @running = true
    @setInterval()

  stop: ->
    console.log('stop')
    @updateTimer()
    @running = false
    @clearTimeout()

  updateTimer: ->
    @timer = Date.now() - @start_time

  reset: ->
    console.log('reset')
    @start_time = null
    @timer = 0
    @running = false
    @clearTimeout()

  toggle: ->
    console.log('toggle', @running)
    if @running
      @stop()
    else
      @start()

  render: ->
    console.log('render')
    time = @calculateTime()
    @el.html("#{time} s")

  calculateTime: ->
    return 0 unless @start_time?
    Math.floor((Date.now() - @start_time) / 1000)

  setInterval: ->
    @interval = window.setTimeout(@onInterval, @interval_time)

  clearTimeout: ->
    console.log('clearTimeout')
    if @interval?
      window.clearTimeout(@interval)
      @interval = null

  onInterval: =>
    # TODO: Render list, update timer, add current class on step, remove current class on other steps
    #console.log('onInterval')
    @render()
    @setInterval()
  
(exports ? this).BrewTimer = BrewTimer
