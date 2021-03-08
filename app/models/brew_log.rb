class BrewLog < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates :brewed_at, presence: true
end
