class MediaTools {
  constructor(thumbnail, btnsel, slider) {
    this.removeMedium = this.removeMedium.bind(this);
    this.hoverOver = this.hoverOver.bind(this);
    this.hoverOut = this.hoverOut.bind(this);
    this.thumbnail = thumbnail;
    this.btnsel = btnsel;
    this.slider = slider;
    this.$slider = $(this.slider);
  }

  init() {
    this.$slider.on("mouseenter", this.thumbnail, this.hoverOver);
    this.$slider.on("mouseleave", this.thumbnail, this.hoverOut);
    this.$slider.on("ajax:success", ".destroy-button", this.removeMedium);
    $(".fancybox").fancybox({
      openEffect: "elastic",
      closeEffect: "fade",
      preload: 3
    });
  }

  removeMedium(ev) {
    //console.log(ev.target, $(ev.target).parents(@thumbnail))
    $(ev.target).parents(this.thumbnail).remove();
    this.$slider.trigger("media:update");
  }

  hoverOver(ev) {
    const $medium = $(ev.currentTarget);
    const $btn = this.button($medium);
    //console.log('hoverOver', $medium, $btn)
    $btn.show().position({
      my: "right top",
      at: "right-4 top+4",
      of: $medium.find("img")
    });
  }

  hoverOut(ev) {
    const $medium = $(ev.currentTarget);
    this.button($medium).hide();
  }

  button($medium) {
    return $medium.find(this.btnsel);
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).MediaTools = MediaTools;

