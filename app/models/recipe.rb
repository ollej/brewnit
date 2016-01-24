class Recipe < ActiveRecord::Base
  include SearchCop

  search_scope :search do
    attributes primary: [:name, :description, :style_name, :brewer]
    attributes :abv, :ibu, :og, :fg, :color, :batch_size, :style_code, :style_guide, :style_name, :created_at, :brewer
    attributes owner: 'user.name'
    options :primary, type: :fulltext, default: true
    options :owner, type: :fulltext, default: true
    options :style_name, type: :fulltext, default: false
  end

  belongs_to :user
  belongs_to :media_main, class_name: "Medium"
  has_many :media, as: :parent, dependent: :destroy
  accepts_nested_attributes_for :media, :reject_if => lambda { |r| r['media'].nil? }

  after_create :notify_pushover

  before_save :extract_details, if: Proc.new { |r| r.errors.empty? }
  validates :beerxml, presence: true, beerxml: true

  acts_as_commontable
  acts_as_votable

  default_scope { where(public: true) }
  scope :for_user, -> (user) { unscoped.where('user_id = ? OR public = true', user.id) }
  scope :by_user, -> (user) { where(user: user) }
  scope :ordered, -> { order(created_at: :desc) }

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

  def brewer_name
    if user.present? && user.brewery.present?
      user.brewery
    elsif brewer.present?
      brewer
    else
      owner_name
    end
  end

  def display_desc
    if description.present?
      description
    else
      style_name
    end
  end

  def main_image(size = :medium_thumbnail)
    if media_main.present?
      media_main.file.url(size)
    elsif user.present?
      if user.media_brewery.present?
        user.media_brewery.file.url(size)
      else
        user.avatar_image(size)
      end
    end
  end

  def comments
    thread.comments.size
  end

  def beerxml_details
    @beerxml_details ||= parse_beerxml(self.beerxml)
  end

  def parse_beerxml(beerxml)
    parser = NRB::BeerXML::Parser.new(perform_validations: false)
    xml = StringIO.new(beerxml)
    recipe = parser.parse(xml)
    BeerRecipe::RecipeWrapper.new(recipe.records.first)
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
    self.brewer = beerxml_details.brewer
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
      aau: hop.aau,
      mgl_alpha: hop.mgl_added_alpha_acids,
      grams_per_liter: hop.amount / batch_size,
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

  def notify_pushover
    return if Rails.env.development?
    values = {
      recipe_name: name,
      brewer_name: brewer_name,
      style_name: style_name
    }
    user = if public?
      Rails.application.secrets.pushover_group_recipe
    else
      Rails.application.secrets.pushover_user
    end
    Pushover.notification(
      user: user,
      title: I18n.t(:'common.notification.recipe.created.title', values),
      message: I18n.t(:'common.notification.recipe.created.message', values),
      sound: 'incoming',
      url: Rails.application.routes.url_helpers.recipe_url(self)
    )
  end

  def self.styles
    self.uniq.pluck(:style_name).map(&:capitalize).uniq.sort
  end
end
