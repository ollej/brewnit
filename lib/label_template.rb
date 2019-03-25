class LabelTemplate
  include ActiveModel::Validations

  EXCLUDE_SANITIZATION = %i(logo qrcode)

  attr_accessor :name, :description1, :description2, :description3,
    :description4, :abv, :ibu, :ebc, :og, :fg, :brewdate, :contactinfo,
    :bottlesize, :logo, :qrcode

  validates :name, presence: true

  def initialize(template, data)
    @doc = Nokogiri::XML.parse(template)
    data.each do |attribute, value|
      value = sanitize_field(value) unless excluded?(attribute)
      send("#{attribute}=", value) if respond_to? "#{attribute}="
    end
  end

  def generate
    build.to_s
  end

  private
  def build
    update_fields([
      LabelField.new(css: "#beername", value: name),
      LabelField.new(css: "#description1", value: description1),
      LabelField.new(css: "#description2", value: description2),
      LabelField.new(css: "#description3", value: description3),
      LabelField.new(css: "#description4", value: description4),
      LabelField.new(css: "#beerdetails1", value: abv, header: "ABV"),
      LabelField.new(css: "#beerdetails2", value: ibu, header: "IBU"),
      LabelField.new(css: "#beerdetails3", value: ebc, header: "EBC"),
      LabelField.new(css: "#beerdetails4", value: og, header: "OG"),
      LabelField.new(css: "#beerdetails5", value: fg, header: "FG"),
      LabelField.new(css: "#beerdetails6", value: "Bryggdatum:", clear: brewdate.blank?),
      LabelField.new(css: "#beerdetails7", value: brewdate),
      LabelField.new(css: "#beerdetails8", value: contactinfo),
      LabelField.new(css: "#bottlesize", value: bottlesize)
    ])
    image("#logo", logo)
    image("#qrcode", qrcode)
    @doc
  end

  def content(css, content)
    begin
      @doc.at_css(css).content = content
    rescue NoMethodError
      Rails.logger.warn { "CSS not found: #{css}" }
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

  def image(css, file)
    if file.present?
      @doc.at_css(css).set_attribute("xlink:href", ImageData.new(file).data)
    end
  end

  def excluded?(attribute)
    EXCLUDE_SANITIZATION.include? attribute.to_sym
  end

  def sanitize_field(value)
    sanitizer.sanitize(value)
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
