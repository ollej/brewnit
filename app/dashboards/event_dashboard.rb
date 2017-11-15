require "administrate/base_dashboard"

class EventDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    recipes: Field::HasMany,
    media_main: MediumField,
    media: Field::HasMany,
    placements: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    description: Field::Text,
    organizer: Field::String,
    location: Field::String,
    held_at: Field::DateTime,
    event_type: Field::String,
    url: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    media_main_id: Field::Number,
    last_registration: Field::DateTime,
    locked: Field::Boolean,
    official: Field::Boolean,
    address: Field::Text,
    coordinates: Field::String,
    contact_email: Field::Email,
    registration_information: Field::Text,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :media_main,
    :name,
    :held_at,
    :event_type,
    :organizer,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :description,
    :organizer,
    :location,
    :address,
    :coordinates,
    :held_at,
    :event_type,
    :url,
    :contact_email,
    :last_registration,
    :registration_information,
    :locked,
    :official,
    :user,
    :created_at,
    :updated_at,
    :media_main,
    #:media_main_id,
    :media,
    :recipes,
    #:placements,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :description,
    :organizer,
    :location,
    :address,
    :coordinates,
    :held_at,
    :event_type,
    :url,
    :contact_email,
    :last_registration,
    :registration_information,
    :locked,
    :official,
    :user,
    :recipes,
    :media_main,
    #:media_main_id,
    :media,
    #:placements,
  ].freeze

  # Overwrite this method to customize how events are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(event)
    event.name
  end
end
