class BrewTimerDialog
  constructor: (@el, @link) ->

  init: ->
    console.log('modal-content', $('#brew-timer'))
    $("#brew-timer")
      .on('shown.bs.modal', @setupEvents)
      .on('hidden.bs.modal', @cancelEvents)
    @loadSteps(38)

  loadSteps: (id) ->
    $.get("/recipe_steps/#{id}", @storeSteps)

  storeSteps: (data) =>
    @steps = data
    @timer = new BrewTimer($('.timer-steps', $(@el)), @steps)
    console.log @steps

  setupEvents: =>
    console.log('setup events')
    $(@link).on("click", @toggleTimer)
    # TODO: Only when modal is active
    $(window).on("keypress", @keyPressed)
    
  keyPressed: (ev) =>
    @toggleTimer() if (ev.keyCode == 0 || ev.keyCode == 32)
    return false

  cancelEvents: =>
    console.log('cancel events')
    $(@link).off("click", @toggleTimer)
    $(window).off("keypress", @keyPressed)

  toggleTimer: =>
    console.log('toggleTimer')
    @timer?.toggle()
    # TODO: Switch button between play/pause
  
(exports ? this).BrewTimerDialog = BrewTimerDialog
