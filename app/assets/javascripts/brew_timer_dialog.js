class BrewTimerDialog {
  constructor(el, recipeEl) {
    this.el = $(el);
    this.startEl = this.el.find(".brew-timer-start");
    this.pauseEl = this.el.find(".brew-timer-pause");
    this.resetEl = this.el.find(".brew-timer-reset");
    this.recipeEl = recipeEl;
  }

  init() {
    console.log('BrewTimerDialog', this.el, $(this.recipeEl));
    if ($(this.recipeEl).length == 0) {
      return;
    }
    this.el
      .on('shown.bs.modal', this.setupDialog.bind(this))
      .on('hidden.bs.modal', this.cancelDialog.bind(this));
  }

  loadSteps(id) {
    console.log("loadSteps", id);
    $.get(`/recipe_steps/${id}`, this.storeSteps.bind(this));
  }

  storeSteps(data) {
    console.log("storeSteps", data);
    this.steps = data;
    this.timer = new BrewTimer(this.el.find('.timer-steps'), this.steps);
    console.log(this.steps);
  }

  setupDialog() {
    console.log('setup events');
    this.setupTimer();
    this.startEl.on("click", this.toggleTimer.bind(this));
    this.pauseEl.on("click", this.toggleTimer.bind(this));
    this.resetEl.on("click", this.resetTimer.bind(this));
    // TODO: Only when modal is active
    $(window).on("keypress", this.keyPressed.bind(this));
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
    this.startEl.off("click", this.toggleTimer.bind(this));
    this.pauseEl.off("click", this.toggleTimer.bind(this));
    this.resetEl.off("click", this.resetTimer.bind(this));
    $(window).off("keypress", this.keyPressed.bind(this));
  }

  togglePlayButton() {
    console.log("togglePlayButton, timer running?", this.timer.running);
    this.startEl.toggleClass("hidden");
    this.pauseEl.toggleClass("hidden");
  }

  resetTimer() {
    console.log("resetTimer");
    if (this.timer) {
      this.timer.reset();
      this.togglePlayButton();
    }
    return false;
  }

  toggleTimer() {
    console.log('toggleTimer');
    if (this.timer) {
      this.timer.toggle();
      this.togglePlayButton();
    }
    return false;
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).BrewTimerDialog = BrewTimerDialog;
