class BrewTimer extends EventTarget {
  // TODO: Configuration
  // TODO: Listen to start/stop events
  // TODO: Find current step in list

  constructor(el, steps, stepType) {
    super();
    this.interval_time = 100;
    this.increment = 1000;
    this.el = el;
    this.steps = steps;
    this.stepType = stepType;
    this.reset();
  }

  start() {
    if (this.start_time != null) {
      this.start_time = Date.now() - this.elapsed_time;
    } else {
      this.start_time = Date.now();
    }
    this.running = true;
    this.setInterval();
    this.fire("start");
  }

  stop() {
    this.updateElapsedTime();
    this.running = false;
    this.clearTimeout();
    this.fire("stop");
  }

  reset() {
    this.start_time = null;
    this.elapsed_time = 0;
    this.currentStep = -1;
    this.running = false;
    this.clearTimeout();
    this.renderTime(0);
    this.render();
    this.fire("reset");
  }

  toggle() {
    if (this.running) {
      this.stop();
    } else {
      this.start();
    }
  }

  // Private methods

  render() {
    this.el.html(this.renderSteps(this.steps));
    this.timerEl = this.el.find(".timer-time");
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
        <div class="timer-step-icon pure-u-1-8">
          <div class="timer-step-image timer-step-${this.stepType}"></div>
          <span class="timer-step-starttime"></span>
        </div>
        <div class="timer-step-info pure-u-3-4">
          <div class="pure-g">
            <div class="timer-step-name pure-u-1">${step.name}</div>
            <div class="timer-step-description pure-u-1">${step.description}</div>
          </div>
        </div>
        <div class="timer-step-time pure-u-1-8"><span>${this.humanReadableDuration(step.time)}</span></div>
      </div>
    `;
  }

  renderTime(time) {
    if (this.timerEl) {
      this.timerEl.html(this.humanReadableDuration(time));
    }
  }

  startTime(time) {
    let starttime = new Date();
    starttime.setTime(starttime.getTime() + time * 1000);
    return starttime;
  }

  formatTime(date) {
    return dateFormat(date, "HH:MM");
  }

  highlightStep(time) {
    let accumulatedTime = 0;
    this.steps.forEach((step, index) => {
      let $el = this.el.find(".timer-step-" + index);
      accumulatedTime += step["time"];
      if (accumulatedTime - step["time"] <= time) {
        if (this.currentStep < index) {
          this.currentStep = index;
          $el.addClass("timer-step-current");
          $el
            .next(".timer-step")
            .find(".timer-step-starttime")
            .html(this.formatTime(this.startTime(step["time"])));
          this.fire("step");
        }
      }
      if (time >= accumulatedTime) {
        $el.addClass("timer-step-passed");
        $el.removeClass("timer-step-current");
      }
    });
  }

  humanReadableDuration(time) {
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

  totalTime() {
    if (!this._totalTime) {
      this._totalTime = this.steps.reduce((accumulator, step) => accumulator + parseInt(step["time"]), 0);
    }
    return this._totalTime;
  }

  updateElapsedTime() {
    this.elapsed_time = Date.now() - this.start_time;
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
    const time = this.calculateTime();
    if (time < this.totalTime()) {
      this.renderTime(time);
      this.highlightStep(time);
      this.setInterval();
    } else {
      this.fire("done");
      this.reset();
    }
  }

  fire(event) {
    this.dispatchEvent(new Event("brewtimer." + event));
    this.dispatchEvent(new Event("brewtimer.update"));
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).BrewTimer = BrewTimer;
