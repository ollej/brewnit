class ShbfClient
  include HTTParty
  base_uri 'https://styles.shbf.se'
  format :json

  def initialize(year, options = {})
    @options = options
    @year = year
  end

  def request(path, options = {})
    Rails.logger.debug { "Requesting SHBF style guide: #{self.class.base_uri}#{path}, options: #{options}" }
    begin
      self.class.get(path, options)
    rescue JSON::ParserError => e
      Rails.logger.error { "JSON parse error: #{e.message}" }
    end
  end

  def style(category_number, style_letter = nil)
    path = "/json/#{@year}/styles/#{category_number}"
    path += "/#{style_letter}" if style_letter.present?
    request(path)
  end

  def styles
    path = "/json/#{@year}/styles"
    request(path, @options)
  end

  def import
    styles.each do |category|
      Rails.logger.debug { "Importing #{category['name']}" }
      category_data = {
        'number' => category['number'].to_i,
        'category' => category['name'],
        'style_guide' => "SHBF #{@year}"
      }
      category['styles'].each do |style_data|
        create_style(style_data.merge(category_data))
      end
    end
  end

  def create_style(data)
    query = data.slice('style_guide', 'letter', 'number')
    Style.where(query).first_or_initialize.tap do |style|
      style.update!(from_shbf(data))
    end
  end

  def from_shbf(data)
    {
      style_guide: data['style_guide'],
      category: data['category'],
      name: data['name'],
      letter: data['letter'].upcase,
      number: data['number'].to_i,
      og_min: data['ogMin'] || "1.000",
      og_max: data['ogMax'] || "1.200",
      fg_min: data['fgMin'] || "1.000",
      fg_max: data['fgMax'] || "1.200",
      ebc_min: data['ebcMin'] || 0,
      ebc_max: data['ebcMax'] || 120,
      ibu_min: data['ibuMin'] || 0,
      ibu_max: data['ibuMax'] || 200,
      abv_min: data['abvMin'] || 0,
      abv_max: data['abvMax'] || 100,
      description: data['description'] || '',
      aroma: data['aroma'] || '',
      appearance: data['appearance'] || '',
      flavor: data['flavor'] || '',
      texture: data['texture'] || '',
      examples: data['examples'] || '',
      summary: data['summary'] || ''
    }
  end
end
