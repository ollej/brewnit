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

  belongs_to :user
  belongs_to :recipe
  belongs_to :event

  scope :ordered, -> { order(medal: :asc, created_at: :desc) }

  def owned_by?(u)
    self.user == u
  end

  def medal_position
    MEDALS[medal.to_sym]
  end
end
