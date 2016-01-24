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
      done: @handleUploads,
      always: @afterUpload,
      progressall: @updateProgress
    })
  
  updateScroller: ->
    images = @$slider.find("img").length
    #console.log("updateScroller", images)
    @$slider.toggle(images > 0)
    @$slider.mThumbnailScroller("update")
    @$slider.mThumbnailScroller("scrollTo", "last")

  updateProgress: (ev, data) =>
    # FIXME: Uploading multiple images only show progress for first image.
    progress = parseInt(data.loaded / data.total * 100, 10)
    #$("#upload-progress .bar").css("width", "#{progress}%")
    progress = false if progress == 100
    $("#progressbar").show().progressbar({ value: progress })

  handleUploads: (ev, data) =>
    media = data.result.media
    $.each(media, (idx, medium) => @addMedium(medium))
    @$slider.trigger('media:update')

  afterUpload: (ev, data) =>
    $("#progressbar").hide()

  addMedium: (medium) ->
    @$slider.find("ul").append(medium.template)

(exports ? this).MediaUpload = MediaUpload

