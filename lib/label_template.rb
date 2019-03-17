class LabelTemplate
  include ActiveModel::Validations

  EXCLUDE_SANITIZATION = %(logo, qrcode)

  attr_accessor :name, :description1, :description2, :description3,
    :description4, :abv, :ibu, :ebc, :og, :fg, :brewdate, :contactinfo,
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
    content("#beername", name)
    content("#description1", description1)
    content("#description2", description2)
    content("#description3", description3)
    content("#description4", description4)
    details([
      Detail.new("ABV", abv),
      Detail.new("IBU", ibu),
      Detail.new("EBC", ebc),
      Detail.new("OG", og),
      Detail.new("FG", fg)
    ])
    if brewdate.present?
      content("#beerdetails7", brewdate)
    else
      clear("#beerdetails6")
      clear("#beerdetails7")
    end
    content("#beerdetails8", contactinfo)
    content("#bottlesize", bottlesize)
    image("#logo", logo) if logo.present?
    image("#qrcode", qrcode) if qrcode.present?
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

  def details(details)
    details.select! { |detail| detail.has_value? }
    5.times do |index|
      detail = details.fetch(index, Detail.new)
      detail("#beerdetails#{index + 1}", detail)
    end
  end

  def detail(css, detail)
    content(css, detail.content)
  end

  def image(css, file)
    @doc.at_css(css).set_attribute("xlink:href", ImageData.new(file).data)
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
