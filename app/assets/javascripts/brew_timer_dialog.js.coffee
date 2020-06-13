class BrewTimerDialog
  constructor: (@el, @link, @recipeEl) ->

  init: ->
    console.log('BrewTimerDialog', $(@el), $(@recipeEl))
    return unless $(@recipeEl).length > 0
    $("#brew-timer")
      .on('shown.bs.modal', @setupDialog)
      .on('hidden.bs.modal', @cancelDialog)

  loadSteps: (id) ->
    console.log("loadSteps", id)
    $.get("/recipe_steps/#{id}", @storeSteps)

  storeSteps: (data) =>
    console.log("storeSteps", data)
    @steps = data
    @timer = new BrewTimer($('.timer-steps', $(@el)), @steps)
    console.log @steps

  setupDialog: =>
    console.log('setup events')
    @setupTimer()
    $(@link).on("click", @toggleTimer)
    # TODO: Only when modal is active
    $(window).on("keypress", @keyPressed)

  setupTimer: =>
    recipe = $(@recipeEl).data("recipeId")
    console.log("recipe", recipe)
    @loadSteps(recipe)
    
  keyPressed: (ev) =>
    @toggleTimer() if (ev.keyCode == 0 || ev.keyCode == 32)
    return false

  cancelDialog: =>
    console.log('cancel events')
    $(@link).off("click", @toggleTimer)
    $(window).off("keypress", @keyPressed)

  toggleTimer: =>
    console.log('toggleTimer')
    @timer?.toggle()
    # TODO: Switch button between play/pause
    false
  
(exports ? this).BrewTimerDialog = BrewTimerDialog
