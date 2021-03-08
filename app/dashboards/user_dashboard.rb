require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    recipes: Field::HasMany,
    media: Field::HasMany,
    media_avatar: MediumField,
    media_brewery: MediumField,
    #comments: Field::HasMany.with_options(class_name: "Commontator::Comment"),
    #subscriptions: Field::HasMany.with_options(class_name: "Commontator::Subscription"),
    #votes: Field::HasMany.with_options(class_name: "ActsAsVotable::Vote"),
    id: Field::Number,
    name: Field::String,
    email: Field::String,
    encrypted_password: Field::String,
    reset_password_token: Field::String,
    reset_password_sent_at: Field::DateTime,
    remember_created_at: Field::DateTime,
    sign_in_count: Field::Number,
    current_sign_in_at: Field::DateTime,
    last_sign_in_at: Field::DateTime,
    current_sign_in_ip: IpField.with_options(searchable: false),
    last_sign_in_ip: IpField.with_options(searchable: false),
    confirmation_token: Field::String,
    confirmed_at: Field::DateTime,
    confirmation_sent_at: Field::DateTime,
    unconfirmed_email: Field::String,
    failed_attempts: Field::Number,
    unlock_token: Field::String,
    locked_at: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    admin: Field::Boolean,
    presentation: Field::Text,
    location: Field::String,
    brewery: Field::String,
    twitter: Field::String,
    url: Field::String,
    equipment: Field::String,
    media_avatar_id: Field::Number,
    media_brewery_id: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :media_avatar,
    :name,
    :brewery,
    :location,
    :created_at,
    :last_sign_in_ip,
    :recipes,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :email,
    :presentation,
    :location,
    :brewery,
    :twitter,
    :url,
    :equipment,
    :media_avatar,
    :media_brewery,
    #:comments,
    #:subscriptions,
    #:votes,
    #:encrypted_password,
    #:reset_password_token,
    #:reset_password_sent_at,
    #:remember_created_at,
    :sign_in_count,
    #:current_sign_in_at,
    #:last_sign_in_at,
    :current_sign_in_ip,
    :last_sign_in_ip,
    #:confirmation_token,
    #:confirmed_at,
    #:confirmation_sent_at,
    #:unconfirmed_email,
    #:failed_attempts,
    #:unlock_token,
    #:locked_at,
    :created_at,
    :updated_at,
    :admin,
    #:media_avatar_id,
    #:media_brewery_id,
    :recipes,
    :media,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :email,
    :admin,
    :presentation,
    :location,
    :brewery,
    :twitter,
    :url,
    :equipment,
    :recipes,
    :media,
    :media_avatar,
    :media_brewery,
    #:comments,
    #:subscriptions,
    #:votes,
    #:encrypted_password,
    #:reset_password_token,
    #:reset_password_sent_at,
    #:remember_created_at,
    #:sign_in_count,
    #:current_sign_in_at,
    #:last_sign_in_at,
    #:current_sign_in_ip,
    #:last_sign_in_ip,
    #:confirmation_token,
    #:confirmed_at,
    #:confirmation_sent_at,
    #:unconfirmed_email,
    #:failed_attempts,
    #:unlock_token,
    #:locked_at,
    #:media_avatar_id,
    #:media_brewery_id,
  ].freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(user)
    "#{user.display_name(user.email)} (##{user.id})"
  end
end
