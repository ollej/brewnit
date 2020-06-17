class ImageData
  def initialize(file)
    @file = file
  end

  def data
    "data:#{mime};base64,#{base64}"
  end

  private
  def mime
    Marcel::MimeType.for @file
  end

  def base64
    Base64.strict_encode64(@file)
  end
end
