class Placement < ActiveRecord::Base
  MEDALS = {
    gold: 1,
    silver: 2,
    bronze: 3
  }

  enum medal: {
    gold: 'gold',
    silver: 'silver',
    bronze: 'bronze'
  }

  validates :user, presence: true
  validates :recipe, presence: true
  validates :event, presence: true
  validate :official_event_registration

  belongs_to :user
  belongs_to :recipe
  belongs_to :event

  scope :by_recipe, -> (recipe) { where(recipe: recipe) }
  scope :by_event, -> (event) { where(event: event) }
  scope :ordered, -> { order(medal: :asc, created_at: :desc) }

  def owned_by?(u)
    self.user == u
  end

  def medal_position
    MEDALS[medal.to_sym]
  end

  def official_event_registration
    if event.official? && !user.can_modify?(event)
      errors.add(:base, I18n.t(:'activerecord.errors.models.placement.no_placement_on_official_event'))
    end
  end
end
