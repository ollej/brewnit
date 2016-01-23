class MediaUpload
  constructor: (@button, @filefield, @images) ->
    @$button = $(@button)
    @$images = $(@images)

  init: ->
    @$button.click(=> $(@filefield).trigger('click'))
    $(@filefield).fileupload({
      dataType: 'json',
      done: (e, data) => @handleUploads(data.result.media),
      progressall: (e, data) => @updateProgress(data)
    })

  updateProgress: (data) ->
    progress = parseInt(data.loaded / data.total * 100, 10)
    console.log('progress', progress, data)
    $("#upload-progress .bar").css("width", "#{progress}%")

  handleUploads: (media) ->
    $.each(media, (idx, medium) => @addMedium(medium))

  addMedium: (medium) ->
    console.log('addMedia', medium)
    console.log(@imageTemplate(medium))
    @$images.append(@imageTemplate(medium))
    $("#slider").mThumbnailScroller("scrollTo", "last")

  imageTemplate: (medium) ->
    "<li><a href='#{medium.url}'><img src='#{medium.scaled.small}'></a></li>"
  
(exports ? this).MediaUpload = MediaUpload

