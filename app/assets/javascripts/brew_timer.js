class BrewTimer extends EventTarget {
  // TODO: Configuration
  // TODO: Listen to start/stop events
  // TODO: Find current step in list

  constructor(el, steps, stepType) {
    super();
    this.intervalTime = 100;
    this.increment = 1000;
    this.el = el;
    this.steps = steps;
    this.stepType = stepType;
    this.countDown = true;
    //this.steps.map((step, index) => {
    //  step["time"] = 5;
    //  step["starttime"] = 5 * index;
    //  step["endtime"] = 5 * (index + 1);
    //  return step;
    //});
    this.reset();
  }

  start() {
    if (this.startTime != null) {
      this.startTime = Date.now() - this.elapsedTime;
    } else {
      this.startTime = Date.now();
    }
    this.running = true;
    this.renderTimes();
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
    this.startTime = null;
    this.elapsedTime = 0;
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

  toggleCountDown() {
    this.countDown = !this.countDown;
  }

  getCurrentStep() {
    return this.steps[this.currentStep];
  }

  nextStep() {
    const step = this.getCurrentStep();
    this.startTime = Date.now() - step["endtime"] * 1000;
    this.renderTimes();
  }

  previousStep() {
    const step = this.steps[this.currentStep - 1];
    if (step) {
      this.startTime = Date.now() - step["starttime"] * 1000;
      this.setCurrentStep(this.currentStep - 1);
    } else {
      this.startTime = Date.now();
    }
    this.renderStepTime(this.currentStep + 1);
    this.renderTimes();
  }

  // Private methods

  render() {
    this.el.html(this.renderSteps(this.steps));
    this.timerEl = this.el.find(".timer-time");
  }

  renderSteps(steps) {
    return `
      <div class="timer-data">
        <div class="timer-time">${this.humanReadableDuration(this.totalTime())}</div>
        <div id="timer-steps">
        ${steps.map(this.renderStep.bind(this)).join('')}
        </div>
        <div class="timer-time-done"></div>
      </div>
    `;
  }

  renderStep(step, index) {
    return `
      <div class="timer-step-${index} timer-step pure-g">
        <div class="timer-step-icon pure-u-1-6 pure-u-md-1-8">
          <div class="timer-step-image timer-step-${step.type}"></div>
          <span class="timer-step-starttime"></span>
        </div>
        <div class="timer-step-info pure-u-2-3 pure-u-md-3-4" data-balloon="${step.description.replace("\n", ", ")}" data-balloon-pos="down">
          <div class="pure-g">
            <div class="timer-step-name pure-u-1">${step.name}</div>
            <div class="timer-step-description pure-u-1">${step.description.replace("\n", "<br>")}</div>
          </div>
        </div>
        <div class="timer-step-time pure-u-1-6 pure-u-md-1-8"><span>${this.humanReadableDuration(step.time)}</span></div>
        <div class="timer-step-description-wide pure-u-1">${step.description.replace("\n", "<br>")}</div>
      </div>
    `;
  }

  renderTime(time) {
    if (this.timerEl) {
      if (this.countDown) {
        time = this.totalTime() - time;
      }
      this.timerEl.html(this.humanReadableDuration(time, true));
    }
  }

  renderTimeToNextStep(time) {
    const step = this.getCurrentStep();
    const timeStr = this.humanReadableDuration(step["endtime"] - time, true);
    this.el.find(`.timer-step-${step["index"]} .timer-step-time span`).html(timeStr);
  }

  renderTimes() {
    this.renderFinishTime();
    this.renderStartTimeForSteps();
  }

  renderStartTimeForSteps() {
    const startDate = new Date(this.startTime);
    this.steps.forEach((step, index) => {
      this.el
          .find(".timer-step-" + index + " .timer-step-starttime")
          .html(this.formatTime(this.addSeconds(step["starttime"], startDate)));
    });
  }

  renderStepTime(stepIndex) {
    const step = this.steps[stepIndex];
    if (step) {
      const timeStr = this.humanReadableDuration(step["time"]);
      this.el.find(`.timer-step-${step["index"]} .timer-step-time span`).html(timeStr);
    }
  }

  renderFinishTime() {
    this.el
      .find(".timer-time-done")
      .html(I18n["brewtimer"]["finish_time"] + this.formatTime(this.addSeconds(this.totalTime(), new Date(this.startTime))));
  }

  addSeconds(seconds, time = new Date()) {
    let newtime = new Date(time.getTime() + seconds * 1000);
    return newtime;
  }

  formatTime(date) {
    return dateFormat(date, "HH:MM");
  }

  highlightStep(time) {
    this.steps.forEach((step, index) => {
      if (time >= step["starttime"] && time < step["endtime"]) {
        if (this.currentStep != index) {
          this.setCurrentStep(index);
        }
      }
    });
  }

  setCurrentStep(index) {
    const cls = this.currentStep < index ? "timer-step-passed" : "timer-step-next";
    this.currentStep = index;
    let $el = this.el.find(".timer-step-" + index);
    this.el.find(".timer-step-current").switchClass("timer-step-current", cls, {
      duration: 500,
      easing: "swing"
    });
    $el.switchClass("timer-step-next timer-step-passed", "timer-step-current", {
      duration: 500,
      easing: "swing",
      queue: true
    });
    $el.next(".timer-step")
      .addClass("timer-step-next");
    $el.prev(".timer-step")
      .addClass("timer-step-passed");
    this.fire("step");
  }

  humanReadableDuration(time, showZero = false) {
    let timestr = "";
    const hours = Math.floor(time / 3600);
    time = time - hours * 3600;
    if (hours > 0) {
      timestr += `${hours}&nbsp;t `;
    }
    const minutes = Math.floor(time / 60);
    time = time - minutes * 60;
    if (minutes > 0) {
      timestr += `${minutes}&nbsp;m `;
    }
    if (showZero || time > 0 || timestr.trim().length == 0) {
      timestr += `${time}&nbsp;s`;
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
    this.elapsedTime = Date.now() - this.startTime;
  }

  calculateTime() {
    if (this.startTime == null) {
      return 0;
    }
    return Math.floor((Date.now() - this.startTime) / 1000);
  }

  setInterval() {
    this.timeoutId = window.setTimeout(this.onInterval.bind(this), this.intervalTime);
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
      this.renderTimeToNextStep(time);
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
