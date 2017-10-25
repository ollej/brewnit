class Event < ActiveRecord::Base
  EVENT_TYPES = ['Tävling', 'Utmaning', 'Träff']

  include SanitizerConcern

  belongs_to :user
  has_and_belongs_to_many :recipes

  before_validation :cleanup_fields
  validates :name, presence: true
  validates :organizer, presence: true
  validates :held_at, presence: true
  validates_inclusion_of :event_type, in: EVENT_TYPES, allow_nil: false
  validates :url, url: true, allow_blank: true

  scope :ordered, -> { order(held_at: :desc) }

  scope :upcoming, -> { where('held_at > ?', Date.today) }
  scope :past, -> { where('held_at <= ?', Date.today) }

  sanitized_fields :description

  def owned_by?(u)
    self.user == u
  end

  def cleanup_fields
    if url.present? && !url.start_with?('http')
      self.url = "http://#{url.strip}"
    end
  end

  def self.event_options
    # TODO: Add held at
    self.all.order(:name).collect {|event| [event.name, event.id]}
  end

end
