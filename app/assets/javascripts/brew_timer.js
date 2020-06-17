class BrewTimer extends EventTarget {
  // TODO: Configuration
  // TODO: Listen to start/stop events
  // TODO: Find current step in list

  constructor(el, steps, stepType) {
    super();
    this.interval_time = 250;
    this.increment = 1000;
    this.el = el;
    this.steps = steps;
    this.stepType = stepType;
    this.currentStep = -1;
    this.totalTime = this.steps.reduce((accumulator, step) => accumulator + parseInt(step["time"]), 0);
    this.reset();
    this.render();
  }

  start() {
    if (this.start_time != null) {
      this.start_time = Date.now() - this.timer;
    } else {
      this.start_time = Date.now();
    }
    this.running = true;
    this.setInterval();
    this.dispatchEvent(new Event("brewtimer.start"));
  }

  stop() {
    this.updateTimer();
    this.running = false;
    this.clearTimeout();
    this.dispatchEvent(new Event("brewtimer.stop"));
  }

  updateTimer() {
    this.timer = Date.now() - this.start_time;
  }

  reset() {
    this.start_time = null;
    this.timer = 0;
    this.currentStep = -1;
    this.running = false;
    this.clearTimeout();
    this.updateTime(0);
    this.render();
    this.dispatchEvent(new Event("brewtimer.reset"));
  }

  toggle() {
    if (this.running) {
      this.stop();
    } else {
      this.start();
    }
  }

  render() {
    this.el.html(this.renderSteps(this.steps));
    this.timerEl = this.el.find(".timer-time");
  }

  renderDone() {
    this.el.html("Klar!");
  }

  renderSteps(steps) {
    return `
      <div class="timer-data">
        <div class="timer-time">0 s</div>
        <div id="timer-steps">
        ${steps.map(this.renderStep.bind(this)).join('')}
        </div>
      </div>
    `;
  }

  renderStep(step, index) {
    return `
      <div class="timer-step-${index} timer-step pure-g">
        <div class="timer-step-icon pure-u-1-8"><div class="timer-step-image timer-step-${this.stepType}"></div></div>
        <div class="timer-step-info pure-u-3-4">
          <div class="pure-g">
            <div class="timer-step-name pure-u-1">${step.name}</div>
            <div class="timer-step-description pure-u-1">${step.description}</div>
          </div>
        </div>
        <div class="timer-step-time pure-u-1-8"><span>${this.displayTime(step.time)}</span></div>
      </div>
    `;
  }

  highlightStep(time) {
    let accumulatedTime = 0;
    this.steps.forEach((step, index) => {
      let $el = this.el.find(".timer-step-" + index);
      accumulatedTime += step["time"];
      if (accumulatedTime - step["time"] <= time) {
        if (this.currentStep < index) {
          this.currentStep = index;
          this.dispatchEvent(new Event("brewtimer.step"));
        }
        $el.addClass("timer-step-current");
      }
      if (time >= accumulatedTime) {
        $el.addClass("timer-step-passed");
        $el.removeClass("timer-step-current");
      }
    });
  }

  displayTime(time) {
    let timestr = "";
    const hours = Math.floor(time / 3600);
    time = time - hours * 3600;
    if (hours > 0) {
      timestr += `${hours} t `;
    }
    const minutes = Math.floor(time / 60);
    time = time - minutes * 60;
    if (minutes > 0) {
      timestr += `${minutes} m `;
    }
    if (time > 0 || timestr.trim().length == 0) {
      timestr += `${time} s`;
    }
    return timestr;
  }

  updateTime(time) {
    if (this.timerEl) {
      this.timerEl.html(this.displayTime(time));
    }
  }

  calculateTime() {
    if (this.start_time == null) {
      return 0;
    }
    return Math.floor((Date.now() - this.start_time) / 1000);
  }

  setInterval() {
    this.timeoutId = window.setTimeout(this.onInterval.bind(this), this.interval_time);
  }

  clearTimeout() {
    if (this.timeoutId != null) {
      window.clearTimeout(this.timeoutId);
      this.timeoutId = null;
    }
  }

  onInterval() {
    // TODO: Render list, update timer, add current class on step, remove current class on other steps
    const time = this.calculateTime();
    if (time < this.totalTime) {
      this.updateTime(time);
      this.highlightStep(time);
      this.setInterval();
    } else {
      this.renderDone();
      this.dispatchEvent(new Event("brewtimer.done"));
      this.reset();
    }
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).BrewTimer = BrewTimer;
