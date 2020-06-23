class BrewTimerDialog {
  constructor(el, recipeId) {
    this.el = el;
    this.recipeId = recipeId;
    this.notify = new Notify();
    this.startEl = this.el.find(".brew-timer-start");
    this.pauseEl = this.el.find(".brew-timer-pause");
    this.resetEl = this.el.find(".brew-timer-reset");
    this.expandEl = this.el.find(".brew-timer-expand");
    this.stepForwardEl = this.el.find(".brew-timer-step-forward");
    this.stepBackwardEl = this.el.find(".brew-timer-step-backward");
    this.sounds = null;
    this.el
      .on('shown.bs.modal', this.setupDialog.bind(this))
      .on('hidden.bs.modal', this.cancelDialog.bind(this));
    this.toggleTimer = this.toggleTimer.bind(this);
    this.resetTimer = this.resetTimer.bind(this);
    this.toggleExpand = this.toggleExpand.bind(this);
    this.toggleCountdown = this.toggleCountdown.bind(this);
    this.stepForward = this.stepForward.bind(this);
    this.stepBackward = this.stepBackward.bind(this);
    this.onFullscreenChange = this.onFullscreenChange.bind(this);
    this.keyPressed = this.keyPressed.bind(this);
  }

  setupDialog() {
    this.setupSounds();
    this.setupTimer();
    this.startEl.on("click", this.toggleTimer);
    this.pauseEl.on("click", this.toggleTimer);
    this.resetEl.on("click", this.resetTimer);
    this.expandEl.on("click", this.toggleExpand);
    this.stepForwardEl.on("click", this.stepForward);
    this.stepBackwardEl.on("click", this.stepBackward);
    this.el.on("click", ".timer-time", this.toggleCountdown);
    $(document).on("fullscreenchange", this.onFullscreenChange);
    $(window).on("keypress", this.keyPressed);
  }

  cancelDialog() {
    this.startEl.off("click", this.toggleTimer);
    this.pauseEl.off("click", this.toggleTimer);
    this.resetEl.off("click", this.resetTimer);
    this.expandEl.off("click", this.toggleExpand);
    this.stepForwardEl.off("click", this.stepForward);
    this.stepBackwardEl.off("click", this.stepBackward);
    this.el.off("click", ".timer-time", this.toggleCountdown);
    $(document).off("fullscreenchange", this.onFullscreenChange);
    $(window).off("keypress", this.keyPressed);
  }

  setupTimer() {
    if (!this.timer) {
      const stepType = this.el.data("stepType");
      const steps = this.el.data("brewtimerSteps");
      this.createTimer(steps, stepType);
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

  createTimer(steps, stepType) {
    this.timer = new BrewTimer(this.el.find('.timer-content'), steps, stepType);
    this.timer.addEventListener("brewtimer.done", (event) => {
      this.togglePlayButton();
    });
    this.timer.addEventListener("brewtimer.step", (event) => {
      if (this.timer.currentStep > 0) {
        this.play("step");
        this.notify.send(I18n["brewtimer"]["notification"]["step"] + this.timer.getCurrentStep()["name"]);
      }
    });
    this.timer.addEventListener("brewtimer.done", (event) => {
      this.play("done");
      this.notify.send(I18n["brewtimer"]["notification"]["done"][this.timer.stepType], "done");
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
    this.notify.requestPermission();
    if (this.timer) {
      this.timer.toggle();
      this.togglePlayButton();
    }
    return false;
  }

  toggleExpand() {
    this.openFullscreen(this.el.find(".timer-content").get(0));
  }

  openFullscreen(el) {
    if (el.requestFullscreen) {
      el.requestFullscreen();
    } else {
      this.expandEl.find("i").toggleClass("fa-expand fa-compress");
    }
  }

  onFullscreenChange(event) {
    if (document.fullscreenElement) {
      this.el.addClass("brewtimer-fullscreen");
    } else {
      this.el.removeClass("brewtimer-fullscreen");
    }
  }

  stepForward() {
    if (this.timer.running) {
      this.timer.nextStep();
    }
  }

  stepBackward() {
    if (this.timer.running) {
      this.timer.previousStep();
    }
  }

  toggleCountdown() {
    this.timer.toggleCountDown();
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).BrewTimerDialog = BrewTimerDialog;
