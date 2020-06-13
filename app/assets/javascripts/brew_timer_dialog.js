class BrewTimerDialog {
  constructor(el, link, recipeEl) {
    this.storeSteps = this.storeSteps.bind(this);
    this.setupDialog = this.setupDialog.bind(this);
    this.setupTimer = this.setupTimer.bind(this);
    this.keyPressed = this.keyPressed.bind(this);
    this.cancelDialog = this.cancelDialog.bind(this);
    this.toggleTimer = this.toggleTimer.bind(this);
    this.el = el;
    this.link = link;
    this.recipeEl = recipeEl;
  }

  init() {
    console.log('BrewTimerDialog', $(this.el), $(this.recipeEl));
    if ($(this.recipeEl).length == 0) {
      return;
    }
    $("#brew-timer")
      .on('shown.bs.modal', this.setupDialog)
      .on('hidden.bs.modal', this.cancelDialog);
  }

  loadSteps(id) {
    console.log("loadSteps", id);
    $.get(`/recipe_steps/${id}`, this.storeSteps);
  }

  storeSteps(data) {
    console.log("storeSteps", data);
    this.steps = data;
    this.timer = new BrewTimer($('.timer-steps', $(this.el)), this.steps);
    console.log(this.steps);
  }

  setupDialog() {
    console.log('setup events');
    this.setupTimer();
    $(this.link).on("click", this.toggleTimer);
    // TODO: Only when modal is active
    $(window).on("keypress", this.keyPressed);
  }

  setupTimer() {
    const recipe = $(this.recipeEl).data("recipeId");
    console.log("recipe", recipe);
    this.loadSteps(recipe);
  }

  keyPressed(ev) {
    if ((ev.keyCode === 0) || (ev.keyCode === 32)) {
      this.toggleTimer();
    }
    return false;
  }

  cancelDialog() {
    console.log('cancel events');
    $(this.link).off("click", this.toggleTimer);
    $(window).off("keypress", this.keyPressed);
  }

  toggleTimer() {
    console.log('toggleTimer');
    if (this.timer != null) {
      this.timer.toggle();
    }
    // TODO: Switch button between play/pause
    return false;
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).BrewTimerDialog = BrewTimerDialog;
