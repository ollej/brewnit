class Recipe < ApplicationRecord
  include MediaParentConcern
  include SearchCop
  include SanitizerConcern
  include PushoverConcern

  search_scope :search do
    attributes primary: [:name, :description, :style_name, :brewer, :equipment]
    attributes :abv, :ibu, :og, :fg, :color, :batch_size, :style_code, :style_guide, :style_name, :created_at, :brewer, :equipment
    attributes owner: 'user.name'
    attributes event: 'events.name'
    attributes event_id: 'events.id'
    attributes medal: 'placements.medal'
    options :primary, type: :fulltext, default: true, dictionary: 'swedish_snowball'
    options :name, type: :fulltext, dictionary: 'swedish_snowball'
    options :owner, type: :fulltext, dictionary: 'swedish_snowball'
    options :style_name, type: :fulltext, dictionary: 'swedish_snowball'
    options :event, type: :fulltext, dictionary: 'swedish_snowball'
  end

  belongs_to :user
  belongs_to :media_main, class_name: 'Medium', optional: true
  has_many :media, as: :parent, dependent: :destroy
  has_and_belongs_to_many :events
  has_many :placements, dependent: :destroy
  has_many :registrations, dependent: :destroy, class_name: 'EventRegistration'
  has_one :detail, dependent: :destroy, class_name: 'RecipeDetail'

  accepts_nested_attributes_for :media, reject_if: lambda { |r| r['media'].nil? }

  before_save :extract_beerxml_details, if: Proc.new { |r|
    r.errors.empty? && beerxml.present?
  }
  validates :beerxml, beerxml: true, allow_blank: true

  acts_as_commontable
  acts_as_votable

  sanitized_fields :description

  default_scope { where(public: true) }
  scope :completed, -> { where(complete: true) }
  scope :for_user, -> (user) {
    unscoped.where('recipes.user_id = ? OR (recipes.public = true AND recipes.complete = true)', user.id)
  }
  scope :by_user, -> (user) { where(user: user) }
  scope :by_event, -> (event) { joins(:events).where(events: { id: event.id }) }
  scope :ordered, -> { order(created_at: :desc) }
  scope :latest, -> { completed.limit(10).ordered }

  def owned_by?(u)
    self.user == u
  end

  def owner_name
    user&.name.presence || '[N/A]'
  end

  def brewer_name
    user&.brewery.presence || brewer.presence || owner_name
  end

  def equipment
    user&.equipment
  end

  def display_desc
    if description.present?
      Rails::Html::FullSanitizer.new.sanitize(description)
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

  def placement
    placements.sort_by { |p| p.medal }.last
  end

  def comments
    thread.comments.size
  end

  def registration_message_for(event)
    registrations.by_event(event).first&.message
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

  def extract_beerxml_details
    return unless beerxml.present?
    self.name = beerxml_details.name unless self.name.present?
    self.abv = beerxml_details.abv
    self.ibu = beerxml_details.ibu
    self.og = beerxml_details.og
    self.fg = beerxml_details.fg
    self.style_code = beerxml_details.style_code
    self.style_guide = beerxml_details.style.try(:style_guide) || ''
    self.style_name = beerxml_details.style.try(:name) || ''
    self.batch_size = beerxml_details.batch_size
    self.color = beerxml_details.color_ebc
    self.brewer = beerxml_details.brewer || ''
    if beerxml_details.equipment.present?
      self.equipment = beerxml_details.equipment.try(:name) || ''
    else
      self.equipment = user.equipment || ''
    end
    self.complete = true
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

  def pushover_values(type = :create)
    translation_values = {
      recipe_name: name,
      brewer_name: brewer_name,
      style_name: style_name
    }
    if type == :create
      super.merge({
        title: I18n.t(:'common.notification.recipe.created.title', translation_values),
        message: I18n.t(:'common.notification.recipe.created.message', translation_values),
        url: Rails.application.routes.url_helpers.recipe_url(self)
      })
    else
      super.merge({
        title: I18n.t(:'common.notification.recipe.destroyed.title', translation_values),
        message: I18n.t(:'common.notification.recipe.destroyed.message', translation_values),
        sound: 'falling'
      })
    end
  end

  def pushover_user
    if public?
      Rails.application.secrets.pushover_group_recipe
    else
      super
    end
  end

  def add_event(event:, user: nil, placement: {}, registration: {})
    event = Event.find(event) unless event.kind_of? Event
    raise RegistrationsClosed if event.registration_closed?
    transaction do
      events << event unless events.include?(event)
      add_placement(event: event, user: user, placement: placement) if placement[:medal].present?
    end
    return event
  end

  def add_placement(event:, user:, placement:)
    Rails.logger.debug { "add_placement #{event.inspect} #{user.inspect} #{placement.inspect}" }
    if !event.official? || user.can_modify?(event)
      Placement.create!(event: event, user: user, recipe: self, medal: placement[:medal], category: placement[:category])
    end
  end

  def remove_event(event)
    transaction do
      events.delete(event)
      placements.by_event(event).destroy_all
      registrations.by_event(event).destroy_all
    end
  end

  def likes_list
    get_likes.map(&:voter).map(&:display_name).to_sentence
  end

  def self.recipe_options(scope)
    scope.map { |recipe| [recipe.name, recipe.id] }
  end

  def self.styles
    self.distinct.pluck(:style_name).map(&:capitalize).uniq.sort
  end

  def self.equipments
    self.distinct.pluck(:equipment).reject { |r| r.empty? }.map(&:capitalize).uniq.sort
  end

end
