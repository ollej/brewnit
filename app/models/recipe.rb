class Recipe < ActiveRecord::Base
  belongs_to :user

  default_scope { where(public: true) }
  scope :for_user, -> (user) { unscoped.where('user_id = ? OR public = true', user.id) }
  scope :by_user, -> (user) { where(user: user) }

  validates :name, presence: true
  validates :beerxml, presence: true

  def owner_name
    if user.present?
      user.name
    else
      '[N/A]'
    end
  end

  def beerxml_details
    @beerxml_details ||= begin
      parser = NRB::BeerXML::Parser.new
      xml = StringIO.new(self.beerxml)
      recipe = parser.parse(xml)
      BeerRecipe::RecipeWrapper.new(recipe.records.first)
    end
  end

  def malt_data
    beerxml_details.fermentables.map do |f|
      {
        label: f.name,
        value: f.formatted_amount.to_f,
        color: f.color_hex,
      }
    end
  end
end
