class LabelTemplate
  def initialize(template, data)
    @data = data
    @doc = Nokogiri::XML.parse(template)
  end

  def generate
    build.to_s
  end

  private
  def build
    content("#beername > tspan > tspan", @data[:name])
    content("#beerdescription1", @data[:description1])
    content("#beerdescription2", @data[:description2])
    content("#beerdescription3", @data[:description3])
    content("#beerdescription4", @data[:description4])
    content("#beerdetails1", "ABV: #{@data[:abv]}")
    content("#beerdetails2", "IBU: #{@data[:ibu]}")
    content("#beerdetails3", "EBC: #{@data[:ebc]}")
    content("#beerdetails6", @data[:bottledate])
    content("#bottlesize > tspan", @data[:bottlesize])
    image("#logo", @data[:logo]) if @data[:logo].present?
    image("#qrcode", @data[:qrcode])
    @doc
  end

  def content(css, content)
    @doc.at_css(css).content = content
  end

  def image(css, file)
    @doc.at_css(css).set_attribute("xlink:href", image_data(file))
  end

  def image_data(file)
    img_mime = Marcel::MimeType.for file
    Rails.logger.debug { "mime: #{img_mime}" }
    img_data = Base64.strict_encode64(file)
    "data:#{img_mime};base64,#{img_data}"
  end
end
