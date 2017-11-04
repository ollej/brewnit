class Event < ActiveRecord::Base
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
  belongs_to :media_main, class_name: 'Medium'
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

  sanitized_fields :description

  def owned_by?(u)
    self.user == u
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

  def self.event_options
    # TODO: Add held at
    self.select(:id, :name).order(:name).collect {|event| [event.name, event.id]}
  end

end
