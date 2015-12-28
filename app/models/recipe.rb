class Recipe < ActiveRecord::Base
  belongs_to :user

  acts_as_commontable
  acts_as_votable

  default_scope { where(public: true).ordered }
  scope :for_user, -> (user) { unscoped.where('user_id = ? OR public = true', user.id).ordered }
  scope :by_user, -> (user) { where(user: user) }
  scope :ordered, -> { order(created_at: :desc) }

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
    if hop.use == 'Boil'
      if hop.time >= 30
        I18n.t(:'beerxml.addition_bitter')
      elsif hop.time >= 10
        I18n.t(:'beerxml.addition_flavour')
      else
        I18n.t(:'beerxml.addition_aroma')
      end
    else
      I18n.t("beerxml.#{hop.use}")
    end
  end

  def hop_additions
    hops = {}
    beerxml_details.hops.map do |h|
      hop_data = { name: h.name, size: h.amount }
      if hops[h.time]
        hops[h.time][:children] << hop_data
      else
        hops[h.time] = { name: hop_addition(h), children: [hop_data] }
      end
    end
    hops
  end

  def hops_data
    {
      name: "hops",
      children: hop_additions.map do |t, hop|
        {
          name: hop[:name],
          children: hop[:children]
        }
      end
    }
  end
end
