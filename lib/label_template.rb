class LabelTemplate
  WIDTH = 591
  HEIGHT = 827
  #  591 x 827 px
  #  620 x 827 px

  include ActiveModel::Validations

  EXCLUDE_SANITIZATION = %i(logo qrcode mainimage mainimage_wide mainimage_full background border)

  attr_accessor :name, :description1, :description2, :description3,
    :description4, :abv, :ibu, :ebc, :og, :fg, :brewdate, :contactinfo,
    :bottlesize, :brewery, :beerstyle, :malt1, :malt2, :hops1, :hops2, :yeast,
    :logo, :qrcode, :background, :border, :textcolor, :logo_url, :qrcode_url,
    :mainimage, :mainimage_wide, :mainimage_full,
    :mainimage_url, :mainimage_wide_url, :mainimage_full_url

  validates :name, presence: true

  def initialize(template, data)
    @doc = Nokogiri::XML.parse(template)
    data.each do |attribute, value|
      value = sanitize_field(value) unless excluded?(attribute)
      send("#{attribute}=", value) if respond_to? "#{attribute}="
    end
  end

  def generate_svg
    build.to_s
  end

  def generate_png
    SvgToPng.new(generate_svg, width: WIDTH, height: HEIGHT).convert
  end

  private
  def build
    update_fields([
      LabelField.new(css: "#beername", value: name),
      LabelField.new(css: "#description1", value: description1),
      LabelField.new(css: "#description2", value: description2),
      LabelField.new(css: "#description3", value: description3),
      LabelField.new(css: "#description4", value: description4),
      LabelField.new(css: "#abv", value: abv),
      LabelField.new(css: "#beerdetails1", value: abv, header: "ABV"),
      LabelField.new(css: "#beerdetails2", value: ibu, header: "IBU"),
      LabelField.new(css: "#beerdetails3", value: ebc, header: "EBC"),
      LabelField.new(css: "#beerdetails4", value: og, header: "OG"),
      LabelField.new(css: "#beerdetails5", value: fg, header: "FG"),
      LabelField.new(css: "#beerdetails6", value: "Bryggdatum:", clear: brewdate.blank?),
      LabelField.new(css: "#beerdetails7", value: brewdate),
      LabelField.new(css: "#beerdetails8", value: contactinfo),
      LabelField.new(css: "#brewdate", value: brewdate),
      LabelField.new(css: "#contactinfo", value: contactinfo),
      LabelField.new(css: "#bottlesize", value: bottlesize),
      LabelField.new(css: "#brewery", value: brewery),
      LabelField.new(css: "#beerstyle", value: beerstyle),
      LabelField.new(css: "#malt-header", value: "Malt:", clear: malt1.blank?),
      LabelField.new(css: "#malt1", value: malt1),
      LabelField.new(css: "#malt2", value: malt2),
      LabelField.new(css: "#hops-header", value: "Humle:", clear: hops1.blank?),
      LabelField.new(css: "#hops1", value: hops1),
      LabelField.new(css: "#hops2", value: hops2),
      LabelField.new(css: "#yeast-header", value: "Jäst:", clear: yeast.blank?),
      LabelField.new(css: "#yeast", value: yeast),
    ])
    image("#logo", logo, logo_url)
    image("#qrcode", qrcode)
    image("#mainimage", mainimage, mainimage_url)
    image("#mainimagewide", mainimage_wide, mainimage_wide_url)
    image("#mainimagefull", mainimage_full, mainimage_full_url)
    image("#background", background)
    image("#border", border)
    set_text_color
    @doc
  end

  def set_text_color
    return unless textcolor.present?
    @doc.css("text tspan").each do |element|
      css = "fill:#{textcolor};stroke: #000000;stroke-width: 0.1px;paint-order:stroke"
      if style = element.attributes["style"]
        element.attributes["style"].value = "#{style};#{css}"
      else
        element["style"] = css
      end
    end
  end

  def content(css, content)
    if node = @doc.css(css)&.first
      node.content = content
    end
  end

  def clear(css)
    content(css, "")
  end

  def update_fields(fields)
    fields.each do |field|
      content(field.css, field.content)
    end
  end

  def image(css, file, url=nil)
    href = file.present? ? ImageData.new(file).data : url
    if href.present?
      @doc.at_css(css)&.set_attribute("xlink:href", href)
    end
  end

  def excluded?(attribute)
    EXCLUDE_SANITIZATION.include? attribute.to_sym
  end

  def sanitize_field(value)
    sanitizer.sanitize(value) unless value.nil?
  end

  def sanitizer
    @sanitizer ||= Sanitizer.new(html_entity_decode: true)
  end

  class LabelField
    attr_reader :css, :value, :header, :clear

    def initialize(css:, value:, header: nil, clear: false)
      @css = css
      @value = value
      @header = header
      @clear = clear
    end

    def content
      if clear
        ""
      elsif value.present? && header.present?
        "#{header}: #{value}"
      else
        value || ""
      end
    end
  end
end
