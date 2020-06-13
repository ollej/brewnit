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
    const time = this.calculateTime();
    this.el.html(`${time} s`);
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
    this.render();
    this.setInterval();
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).BrewTimer = BrewTimer;
