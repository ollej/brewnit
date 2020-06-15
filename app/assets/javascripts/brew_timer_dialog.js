class BrewTimerDialog {
  constructor(el, recipeId) {
    this.el = el;
    this.recipeId = recipeId;
    this.startEl = this.el.find(".brew-timer-start");
    this.pauseEl = this.el.find(".brew-timer-pause");
    this.resetEl = this.el.find(".brew-timer-reset");
    this.el
      .on('shown.bs.modal', this.setupDialog.bind(this))
      .on('hidden.bs.modal', this.cancelDialog.bind(this));
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

  cancelDialog() {
    console.log('cancel events');
    this.startEl.off("click", this.toggleTimer.bind(this));
    this.pauseEl.off("click", this.toggleTimer.bind(this));
    this.resetEl.off("click", this.resetTimer.bind(this));
    $(window).off("keypress", this.keyPressed.bind(this));
  }

  setupTimer() {
    console.log("recipe", this.recipeId);
    if (!this.timer) {
      $.get(`/recipe_steps/${this.recipeId}`, this.storeRecipeSteps.bind(this));
    }
  }

  storeRecipeSteps(data) {
    console.log("storeRecipeSteps", data);
    const stepType = this.el.data("stepType");
    const steps = data[stepType + "_steps"];
    console.log("stepType", stepType, "steps", steps);
    this.timer = new BrewTimer(this.el.find('.timer-content'), steps, stepType);
    this.timer.addEventListener("brewtimer.done", (event) => {
      console.log("timer done!");
      this.togglePlayButton();
    });
    this.timer.addEventListener("brewtimer.step", (event) => {
      console.log("New step started", event.target.currentStep);
    });
  }

  keyPressed(ev) {
    if ((ev.keyCode === 0) || (ev.keyCode === 32)) {
      this.toggleTimer();
    }
    return false;
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
