class EventRegistration < ApplicationRecord
  belongs_to :event
  belongs_to :recipe
  belongs_to :user
end
