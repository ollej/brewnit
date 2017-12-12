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

  belongs_to :user, counter_cache: true
  belongs_to :media_main, class_name: 'Medium', optional: true
  has_many :media, as: :parent, dependent: :destroy
  has_and_belongs_to_many :events
  has_many :placements, dependent: :destroy
  has_many :registrations, dependent: :destroy, class_name: 'EventRegistration'
  has_one :detail, dependent: :destroy, class_name: 'RecipeDetail'

  accepts_nested_attributes_for :media, reject_if: lambda { |r| r['media'].nil? }

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
  scope :with_details, -> (ingredient) { includes(detail: [ingredient]) }
  scope :with_all_details, -> {
    includes(detail: [:fermentables, :hops, :miscs, :yeasts, :style, :mash_steps])
  }

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
