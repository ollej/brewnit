class LabelTemplate
  include ActiveModel::Validations

  EXCLUDE_SANITIZATION = %(logo, qrcode)

  attr_accessor :name, :description1, :description2, :description3,
    :description4, :abv, :ibu, :ebc, :bottledate,
    :bottlesize, :logo, :qrcode

  validates :name, presence: true

  def initialize(template, data)
    @doc = Nokogiri::XML.parse(template)
    data.each do |attribute, value|
      value = sanitize_field(value) unless EXCLUDE_SANITIZATION.include? attribute
      send("#{attribute}=", value) if respond_to? "#{attribute}="
    end
  end

  def generate
    build.to_s
  end

  private
  def build
    content("#beername > tspan > tspan", name)
    content("#beerdescription1", description1)
    content("#beerdescription2", description2)
    content("#beerdescription3", description3)
    content("#beerdescription4", description4)
    details([
      Detail.new("ABV", abv),
      Detail.new("IBU", ibu),
      Detail.new("EBC", ebc)
    ])
    if bottledate.present?
      content("#beerdetails6", bottledate)
    else
      clear("#beerdetails5")
      clear("#beerdetails6")
    end
    content("#bottlesize > tspan", bottlesize)
    image("#logo", logo) if logo.present?
    image("#qrcode", qrcode) if qrcode.present?
    @doc
  end

  def content(css, content)
    @doc.at_css(css).content = content
  end

  def clear(css)
    content(css, "")
  end

  def details(details)
    details.select! { |detail| detail.has_value? }
    3.times do |index|
      detail = details.fetch(index, Detail.new)
      detail("#beerdetails#{index + 1}", detail)
    end
  end

  def detail(css, detail)
    content(css, detail.content)
  end

  def image(css, file)
    @doc.at_css(css).set_attribute("xlink:href", image_data(file))
  end

  def image_data(file)
    img_mime = Marcel::MimeType.for file
    img_data = Base64.strict_encode64(file)
    "data:#{img_mime};base64,#{img_data}"
  end

  def html_entities
    @html_entities ||= HTMLEntities.new
  end

  def sanitize_field(value)
    html_entities.decode Rails::Html::WhiteListSanitizer.new.sanitize(value, tags: [], attributes: [])
  end

  class Detail
    attr_reader :name, :value

    def initialize(name = nil, value = nil)
      @name = name
      @value = value
    end

    def has_value?
      @value.present?
    end

    def content
      if has_value?
        "#{@name}: #{@value}"
      else
        ""
      end
    end
  end
end
