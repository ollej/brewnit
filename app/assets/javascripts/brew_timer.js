class BrewTimer {
  // TODO: Configuration
  // TODO: Listen to start/stop events
  // TODO: Send start/stop/interval events
  // TODO: Render step list
  // TODO: Find current step in list

  constructor(el, steps) {
    this.interval_time = 250;
    this.increment = 1000;
    this.el = el;
    this.steps = steps;
    console.log("steps: ", this.steps);
    this.totalTime = 0;
    this.steps["mash_steps"].forEach(function(step, index) {
      this.totalTime += step["time"];
    }.bind(this));
    this.reset();
    this.render();
  }

  start() {
    console.log('start');
    if (this.start_time != null) {
      this.start_time = Date.now() - this.timer;
    } else {
      this.start_time = Date.now();
    }
    this.running = true;
    this.setInterval();
  }

  stop() {
    console.log('stop');
    this.updateTimer();
    this.running = false;
    this.clearTimeout();
  }

  updateTimer() {
    this.timer = Date.now() - this.start_time;
  }

  reset() {
    console.log('reset');
    this.start_time = null;
    this.timer = 0;
    this.running = false;
    this.clearTimeout();
  }

  toggle() {
    console.log('toggle', this.running);
    if (this.running) {
      this.stop();
    } else {
      this.start();
    }
  }

  render() {
    console.log('render');
    this.el.html(this.renderSteps(this.steps["mash_steps"]));
    this.timerEl = $("#timer-time");
  }

  renderSteps(steps) {
    return `
      <div id="timer-data">
        <div id="timer-time">0 s</div>
        <div id="timer-steps">
        ${steps.map(this.renderStep.bind(this)).join('')}
        </div>
      </div>
    `;
  }

  renderStep(step, index) {
    return `
      <div id="timer-step-${index}" class="timer-step pure-g">
        <div class="timer-step-icon pure-u-1-8"><div class="timer-step-malt"></div></div>
        <div class="timer-step-info pure-u-3-4">
          <div class="pure-g">
            <div class="timer-step-name pure-u-1">${step.name}</div>
            <div class="timer-step-description pure-u-1">${step.description}</div>
          </div>
        </div>
        <div class="timer-step-time pure-u-1-8">${this.displayTime(step.time)}</div>
      </div>
    `;
  }

  highlightStep(time) {
    let accumulatedTime = 0;
    this.steps["mash_steps"].forEach(function(step, index) {
      let $el = $("#timer-step-" + index);
      accumulatedTime += step["time"];
      if (accumulatedTime - step["time"] <= time) {
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
    this.timerEl.html(this.displayTime(time));
  }

  calculateTime() {
    if (this.start_time == null) {
      return 0;
    }
    return Math.floor((Date.now() - this.start_time) / 1000);
  }

  setInterval() {
    this.interval = window.setTimeout(this.onInterval.bind(this), this.interval_time);
  }

  clearTimeout() {
    console.log('clearTimeout');
    if (this.interval != null) {
      window.clearTimeout(this.interval);
      this.interval = null;
    }
  }

  onInterval() {
    // TODO: Render list, update timer, add current class on step, remove current class on other steps
    //console.log('onInterval')
    const time = this.calculateTime();
    if (time < this.totalTime) {
      this.updateTime(time);
      this.highlightStep(time);
      this.setInterval();
    } else {
      this.timerEl.html("Klar!");
      $(".timer-step").addClass("timer-step-passed");
      $(".timer-step").removeClass("timer-step-current");
    }
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).BrewTimer = BrewTimer;
