class Qrcode
  def initialize(url)
    @url = url
  end

  def code
    RQRCode::QRCode.new(@url).as_png(
      size: 236,
      border_modules: 1
    ).to_s
  end

  def image
    ImageData.new(code).data
  end
end
