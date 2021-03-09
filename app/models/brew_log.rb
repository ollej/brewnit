class BrewLog < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates :brewed_at, presence: true

  scope :ordered, -> { order(created_at: :desc) }

  def display_title
    "#{user.brewery_or_name} (#{I18n.l(brewed_at)})"
  end
end
