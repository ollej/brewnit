class BrewTimerDialog {
  constructor(el, recipeId) {
    this.el = el;
    this.recipeId = recipeId;
    this.startEl = this.el.find(".brew-timer-start");
    this.pauseEl = this.el.find(".brew-timer-pause");
    this.resetEl = this.el.find(".brew-timer-reset");
    this.expandEl = this.el.find(".brew-timer-expand");
    this.sounds = null;
    this.el
      .on('shown.bs.modal', this.setupDialog.bind(this))
      .on('hidden.bs.modal', this.cancelDialog.bind(this));
    this.toggleTimer = this.toggleTimer.bind(this);
    this.resetTimer = this.resetTimer.bind(this);
    this.toggleExpand = this.toggleExpand.bind(this);
    this.toggleCountdown = this.toggleCountdown.bind(this);
    this.keyPressed = this.keyPressed.bind(this);
  }

  setupDialog() {
    this.setupSounds();
    this.setupTimer();
    this.startEl.on("click", this.toggleTimer);
    this.pauseEl.on("click", this.toggleTimer);
    this.resetEl.on("click", this.resetTimer);
    this.expandEl.on("click", this.toggleExpand);
    this.el.on("click", ".timer-time", this.toggleCountdown);
    $(window).on("keypress", this.keyPressed);
  }

  cancelDialog() {
    this.startEl.off("click", this.toggleTimer);
    this.pauseEl.off("click", this.toggleTimer);
    this.resetEl.off("click", this.resetTimer);
    this.expandEl.off("click", this.toggleExpand);
    this.el.off("click", ".timer-time", this.toggleCountdown);
    $(window).off("keypress", this.keyPressed);
  }

  setupTimer() {
    if (!this.timer) {
      $.get(`/recipe_steps/${this.recipeId}`, this.storeRecipeSteps.bind(this));
    }
  }

  setupSounds() {
    if (this.sounds) {
      return;
    }
    this.sounds = {};
    ["step", "done"].forEach((sound_type) => {
      this.sounds[sound_type] = new Map();
      window.audio_assets[sound_type].forEach((path, key) => {
        this.sounds[sound_type].set(key, new Howl({ src: [path] }));
      });
    });
  }

  play(sound_type) {
    this.getRandomItem(this.sounds[sound_type]).play();
  }

  getRandomItem(iterable) {
    const randomIndex = Math.floor(Math.random() * iterable.size);
    return iterable.get(Array.from(iterable.keys())[randomIndex]);
  }

  storeRecipeSteps(data) {
    const stepType = this.el.data("stepType");
    const steps = data[stepType + "_steps"];
    this.timer = new BrewTimer(this.el.find('.timer-content'), steps, stepType);
    this.timer.addEventListener("brewtimer.done", (event) => {
      this.togglePlayButton();
    });
    this.timer.addEventListener("brewtimer.step", (event) => {
      if (this.timer.currentStep > 0) {
        this.play("step");
      }
    });
    this.timer.addEventListener("brewtimer.done", (event) => {
      this.play("done");
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

  toggleExpand() {
    this.expandEl.find("i").toggleClass("fa-expand fa-compress");
    this.el.toggleClass("brewtimer-fullscreen");
  }

  toggleCountdown() {
    this.timer.toggleCountDown();
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).BrewTimerDialog = BrewTimerDialog;
