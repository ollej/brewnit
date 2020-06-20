class Flasher {
  constructor(sel) {
    this.clear = this.clear.bind(this);
    this.handler = this.handler.bind(this);
    this.sel = sel;
    this.div().on("click", this.clear);
    $("body")
      .on("flasher:show", this.handler)
      .on("flasher:clear", this.clear);
  }

  div() {
    return this.$div != null ? this.$div : (this.$div = $(this.sel));
  }

  warning(msg) { this.flash(msg, "error"); }
  error(msg) { this.flash(msg, "error"); }
  info(msg) { this.flash(msg, "success"); }
  success(msg) { this.flash(msg, "success"); }

  clear() {
    this.div().html("");
  }

  handler(ev, options) {
    this.flash(options.message, options.level);
  }

  scroll() {
    $("html, body").animate({ scrollTop: 0 }, 500);
    this.div().children().effect("highlight", {}, 750);
  }

  flash(msg, level) {
    if (level == null) { level = "error"; }
    this.div().append(`<div class='pure-alert pure-alert-${level}'>${msg}</div>`);
    this.scroll();
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).Flasher = Flasher;
