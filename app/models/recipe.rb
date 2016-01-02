class Recipe < ActiveRecord::Base
  belongs_to :user

  before_validation :extract_details

  acts_as_commontable
  acts_as_votable

  default_scope { where(public: true).ordered }
  scope :for_user, -> (user) { unscoped.where('user_id = ? OR public = true', user.id).ordered }
  scope :by_user, -> (user) { where(user: user) }
  scope :ordered, -> { order(created_at: :desc) }

  validates :name, presence: true
  validates :beerxml, presence: true, beerxml: true

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

  def extract_details
    self.name = beerxml_details.name unless self.name.present?
    self.abv = beerxml_details.abv
    self.ibu = beerxml_details.ibu
    self.og = beerxml_details.og
    self.fg = beerxml_details.fg
    self.style_code = beerxml_details.style_code
    self.style_guide = beerxml_details.style.style_guide
    self.style_name = beerxml_details.style.name
    self.batch_size = beerxml_details.batch_size
    self.color = beerxml_details.color_ebc
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

  def hop_addition_name(hop)
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

  def hop_data(hop)
    {
      name: hop.name,
      size: hop.amount,
      time: hop.time,
      ibu: hop.ibu,
      tooltip: "#{hop.formatted_amount} #{I18n.t(:'beerxml.grams')} #{hop.name} @ #{hop.formatted_time} #{I18n.t("beerxml.#{hop.time_unit}", default: hop.time_unit)}"
    }
  end

  def hop_additions
    hops = {}
    beerxml_details.hops.map do |h|
      if hops[h.time]
        hops[h.time][:children] << hop_data(h)
      else
        hops[h.time] = { name: hop_addition_name(h), children: [hop_data(h)] }
      end
    end
    hops
  end

  def hops_data
    {
      name: I18n.t(:'beerxml.hops'),
      children: hop_additions.values
    }
  end
end
