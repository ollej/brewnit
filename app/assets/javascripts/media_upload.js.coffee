class MediaUpload
  constructor: (@button, @filefield, @slider) ->
    @$button = $(@button)
    @$slider = $(@slider)

  init: ->
    @$slider.on("media:update", => @updateScroller())
    @updateScroller()
    @$button.click(=> $(@filefield).trigger("click"))
    $(@filefield).fileupload({
      dataType: "json",
      type: 'POST',
      maxFileSize: 2 * 1024 * 1024,
      autoUpload: true,
      disableValidation: false,
      done: @handleUploads,
      always: @afterUpload,
      fail: @handleFailure,
      processalways: @handleProcess,
      progressall: @updateProgress,
      messages: {
        maxFileSize: I18n['fileupload']['errors']['max_file_size_exceeded']
      }
    })
  
  updateScroller: ->
    images = @$slider.find("img").length
    #console.log("updateScroller", images)
    @$slider.toggle(images > 0)
    @$slider.mThumbnailScroller("update")
    @$slider.mThumbnailScroller("scrollTo", "last") if images > 0

  updateProgress: (ev, data) =>
    # FIXME: Uploading multiple images only show progress for first image.
    progress = parseInt(data.loaded / data.total * 100, 10)
    progress = false if progress == 100
    $("#progressbar").show().progressbar({ value: progress })

  handleProcess: (ev, data) =>
    #console.log("handleProcess", ev, data)
    currentFile = data.files[data.index]
    if data.files.error && currentFile.error
      @showError(currentFile.error)

  handleUploads: (ev, data) =>
    media = data.result.media
    $.each(media, (idx, medium) => @addMedium(medium))
    @$slider.trigger('media:update')
    $("body").trigger("flasher:clear")

  handleFailure: (ev, data) =>
    #console.log("handleFailure", ev, data)
    if data.errorThrown?
      @showError(I18n['fileupload']['errors']['backend_error'] + ' ' + data.errorThrown)

  afterUpload: (ev, data) =>
    $("#progressbar").hide()

  showError: (error) =>
    #console.log('MediaUpload.showError', error)
    $("body").trigger("flasher:show", { message: error, level: 'error' })

  addMedium: (medium) ->
    @$slider.find("ul").append(medium.template)

(exports ? this).MediaUpload = MediaUpload

