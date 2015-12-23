class Recipe < ActiveRecord::Base
  belongs_to :user

  acts_as_commontable
  acts_as_votable

  default_scope { where(public: true) }
  scope :for_user, -> (user) { unscoped.where('user_id = ? OR public = true', user.id) }
  scope :by_user, -> (user) { where(user: user) }

  validates :name, presence: true
  validates :beerxml, presence: true

  def owned_by?(u)
    self.user == u
  end

  def owner_name
    if user.present?
      user.name
    else
      '[N/A]'
    end
  end

  def comments
    thread.comments.size
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

  def hop_addition(hop)
    if hop.time > 50
      I18n.t(:'beerxml.addition_bitter')
    elsif hop.time >= 10
      I18n.t(:'beerxml.addition_flavour')
    else
      I18n.t(:'beerxml.addition_aroma')
    end
  end

  def hops_data
    hops = {}
    beerxml_details.hops.map do |h|
      hop_data = { name: h.name, size: h.amount }
      addition = hop_addition(h)
      if hops[addition]
        hops[addition] << hop_data
      else
        hops[addition] = [hop_data]
      end
    end
    {
      name: "hops",
      children: hops.map do |use, hops|
        {
          name: use,
          children: hops
        }
      end
    }
  end
end
