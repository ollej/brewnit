class MediaTools {
  constructor(thumbnail, btnsel, slider) {
    this.removeMedium = this.removeMedium.bind(this);
    this.thumbnail = thumbnail;
    this.btnsel = btnsel;
    this.slider = slider;
    this.$slider = $(this.slider);
  }

  init() {
    this.$slider.on("ajax:success", ".destroy-button", this.removeMedium);
    $(".fancybox").fancybox({
      openEffect: "elastic",
      closeEffect: "fade",
      preload: 3
    });
    return this;
  }

  removeMedium(ev) {
    //console.log(ev.target, $(ev.target).parents(@thumbnail))
    $(ev.target).parents(this.thumbnail).remove();
    this.$slider.trigger("media:update");
  }

  button($medium) {
    return $medium.find(this.btnsel);
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).MediaTools = MediaTools;

