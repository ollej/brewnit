class Event < ApplicationRecord
  EVENT_TYPES = ['Tävling', 'Utmaning', 'Träff']

  include SearchCop
  include SanitizerConcern
  include MediaParentConcern

  search_scope :search do
    attributes primary: [:name, :organizer, :location, :event_type, :description]
    options :primary, type: :fulltext, default: true, dictionary: 'swedish_snowball'
    options :name, type: :fulltext, dictionary: 'swedish_snowball'
  end

  belongs_to :user
  has_and_belongs_to_many :recipes
  belongs_to :media_main, class_name: 'Medium', optional: true
  has_many :media, as: :parent, dependent: :destroy
  has_many :placements, dependent: :destroy

  before_validation :cleanup_fields
  validates :name, presence: true
  validates :organizer, presence: true
  validates :held_at, presence: true
  validates_inclusion_of :event_type, in: EVENT_TYPES, allow_nil: false
  validates :url, url: true, allow_blank: true

  scope :ordered, -> { order(held_at: :desc) }
  scope :upcoming, -> { where('held_at > ?', Date.today) }
  scope :past, -> { where('held_at <= ?', Date.today) }
  scope :latest, -> { limit(10).ordered }
  scope :registration_open, -> {
    where('locked = false AND (last_registration IS NULL OR last_registration > ?)', DateTime.now)
  }

  sanitized_fields :description

  def owned_by?(u)
    self.user == u
  end

  def registration_closed?
    locked? || (last_registration.present? && last_registration < DateTime.now)
  end

  def cleanup_fields
    if url.present? && !url.start_with?('http')
      self.url = "http://#{url.strip}"
    end
  end

  def main_image(size = :medium_thumbnail)
    if media_main.present?
      media_main.file.url(size)
    else
      hash = Digest::MD5.hexdigest(organizer)
      "https://secure.gravatar.com/avatar/#{hash}?s=100&d=retro"
    end
  end

  def option_values
    ["#{name} (#{I18n.l(held_at)})", id]
  end

  def recipe_options
    recipes.map { |recipe| [recipe.name, recipe.id] }
  end

  def self.event_options
    {
      I18n.t(:'events.upcoming_events') =>
      self.registration_open.upcoming.order(:name).collect {|event|
        event.option_values
      },
      I18n.t(:'events.past_events') =>
      self.registration_open.past.order(:name).collect {|event|
        event.option_values
      }
    }
  end

end
