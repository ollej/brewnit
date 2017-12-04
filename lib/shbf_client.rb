class ShbfClient
  include HTTParty
  base_uri 'https://shbf.se'
  format :json

  def initialize(year, options = {})
    @options = options
    @year = year
  end

  def style(category_number, style_letter = nil)
    path = "/styles/json/#{@year}/styles/#{category_number}"
    path += "/#{style_letter}" if style_letter.present?
    self.class.get(path)
  end

  def styles
    self.class.get("/styles/json/#{@year}/styles", @options)
  end

  def import
    styles.each do |category|
      category_data = {
        'number' => category['number'],
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
      style.update(from_shbf(data))
    end
  end

  def from_shbf(data)
    {
      style_guide: data['style_guide'],
      category: data['category'],
      name: data['name'],
      letter: data['letter'].upcase,
      number: data['number'],
      og_min: data['ogMax'],
      og_max: data['ogMin'],
      fg_min: data['fgMin'],
      fg_max: data['fgMax'],
      ebc_min: data['ebcMin'],
      ebc_max: data['ebcMax'],
      ibu_min: data['ibuMin'],
      ibu_max: data['ibuMax'],
      abv_min: data['abvMin'],
      abv_max: data['abvMax'],
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
