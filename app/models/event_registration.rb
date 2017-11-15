class EventRegistration < ApplicationRecord
  belongs_to :event
  belongs_to :recipe
  belongs_to :user

  scope :by_event, -> (event) { where(event: event) }
  scope :by_recipe, -> (recipe) { where(recipe: recipe) }
end
