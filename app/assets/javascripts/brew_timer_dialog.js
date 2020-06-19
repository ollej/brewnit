class BrewTimerDialog {
  constructor(el, recipeId) {
    this.el = el;
    this.recipeId = recipeId;
    this.startEl = this.el.find(".brew-timer-start");
    this.pauseEl = this.el.find(".brew-timer-pause");
    this.resetEl = this.el.find(".brew-timer-reset");
    this.sounds = new Map();
    this.el
      .on('shown.bs.modal', this.setupDialog.bind(this))
      .on('hidden.bs.modal', this.cancelDialog.bind(this));
    this.toggleTimer = this.toggleTimer.bind(this);
    this.resetTimer = this.resetTimer.bind(this);
    this.keyPressed = this.keyPressed.bind(this);
  }

  setupDialog() {
    this.setupSounds();
    this.setupTimer();
    this.startEl.on("click", this.toggleTimer);
    this.pauseEl.on("click", this.toggleTimer);
    this.resetEl.on("click", this.resetTimer);
    $(window).on("keypress", this.keyPressed);
  }

  cancelDialog() {
    this.startEl.off("click", this.toggleTimer);
    this.pauseEl.off("click", this.toggleTimer);
    this.resetEl.off("click", this.resetTimer);
    $(window).off("keypress", this.keyPressed);
  }

  setupTimer() {
    if (!this.timer) {
      $.get(`/recipe_steps/${this.recipeId}`, this.storeRecipeSteps.bind(this));
    }
  }

  setupSounds() {
    if (this.sounds.size > 0) {
      return;
    }
    window.assets.audio.forEach((path, key) => {
      this.sounds.set(key, new Howl({ src: [path] }));
    });
  }

  play() {
    this.getRandomItem(this.sounds).play();
  }

  getRandomItem(iterable) {
    return iterable.get([...iterable.keys()][Math.floor(Math.random() * iterable.size)]);
  }

  storeRecipeSteps(data) {
    const stepType = this.el.data("stepType");
    const steps = data[stepType + "_steps"];
    this.timer = new BrewTimer(this.el.find('.timer-content'), steps, stepType);
    this.timer.addEventListener("brewtimer.done", (event) => {
      this.togglePlayButton();
      this.play();
    });
    // Update modal if content changes
    this.el.modal('handleUpdate');
    this.timer.addEventListener("brewtimer.update", (event) => {
      this.el.modal('handleUpdate');
    });
  }

  keyPressed(ev) {
    if (this.el.is(":hidden")) {
      return;
    }
    if ((ev.keyCode === 0) || (ev.keyCode === 32)) {
      this.toggleTimer();
    }
    return false;
  }

  togglePlayButton() {
    this.startEl.toggleClass("hidden");
    this.pauseEl.toggleClass("hidden");
  }

  resetTimer() {
    if (this.timer) {
      this.timer.reset();
      this.togglePlayButton();
    }
    return false;
  }

  toggleTimer() {
    if (this.timer) {
      this.timer.toggle();
      this.togglePlayButton();
    }
    return false;
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).BrewTimerDialog = BrewTimerDialog;
