class MediaUpload {
  constructor(button, filefield, slider) {
    this.updateProgress = this.updateProgress.bind(this);
    this.handleProcess = this.handleProcess.bind(this);
    this.handleUploads = this.handleUploads.bind(this);
    this.handleFailure = this.handleFailure.bind(this);
    this.afterUpload = this.afterUpload.bind(this);
    this.showError = this.showError.bind(this);
    this.button = button;
    this.filefield = filefield;
    this.slider = slider;
    this.$button = $(this.button);
    this.$slider = $(this.slider);
  }

  init() {
    this.$slider.on("media:update", () => this.updateScroller());
    this.updateScroller();
    this.$button.click(() => $(this.filefield).trigger("click"));
    $(this.filefield).fileupload({
      dataType: "json",
      type: "POST",
      maxFileSize: 2 * 1024 * 1024,
      autoUpload: true,
      disableValidation: false,
      done: this.handleUploads,
      always: this.afterUpload,
      fail: this.handleFailure,
      processalways: this.handleProcess,
      progressall: this.updateProgress,
      messages: {
        maxFileSize: I18n["fileupload"]["errors"]["max_file_size_exceeded"]
      }
    });
  }

  updateScroller() {
    const images = this.$slider.find("img").length;
    //console.log("updateScroller", images)
    this.$slider.toggle(images > 0);
    this.$slider.mThumbnailScroller("update");
    if (images > 0) {
      this.$slider.mThumbnailScroller("scrollTo", "last");
    }
  }

  updateProgress(ev, data) {
    // FIXME: Uploading multiple images only show progress for first image.
    let progress = parseInt((data.loaded / data.total) * 100, 10);
    if (progress === 100) { progress = false; }
    $("#progressbar").show().progressbar({ value: progress });
  }

  handleProcess(ev, data) {
    //console.log("handleProcess", ev, data)
    const currentFile = data.files[data.index];
    if (data.files.error && currentFile.error) {
      this.showError(currentFile.error);
    }
  }

  handleUploads(ev, data) {
    const {
      media
    } = data.result;
    $.each(media, (idx, medium) => this.addMedium(medium));
    this.$slider.trigger("media:update");
    $("body").trigger("flasher:clear");
  }

  handleFailure(ev, data) {
    //console.log("handleFailure", ev, data)
    if (data.errorThrown) {
      this.showError(I18n["fileupload"]["errors"]["backend_error"] + ' ' + data.errorThrown);
    }
  }

  afterUpload(ev, data) {
    return $("#progressbar").hide();
  }

  showError(error) {
    //console.log('MediaUpload.showError', error)
    $("body").trigger("flasher:show", { message: error, level: "error" });
  }

  addMedium(medium) {
    this.$slider.find("ul").append(medium.template);
  }
}

(typeof exports !== 'undefined' && exports !== null ? exports : this).MediaUpload = MediaUpload;

