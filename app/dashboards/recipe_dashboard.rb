require "administrate/base_dashboard"

class RecipeDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo,
    #media_main: Field::BelongsTo.with_options(class_name: "Medium"),
    media_main: MediumField,
    media: Field::HasMany,
    #thread: Field::HasOne,
    #votes_for: Field::HasMany.with_options(class_name: "ActsAsVotable::Vote"),
    id: Field::Number,
    name: Field::String,
    description: Field::Text,
    beerxml: Field::Text,
    public: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    abv: BigDecimalField.with_options(searchable: false),
    ibu: BigDecimalField.with_options(searchable: false),
    og: BigDecimalField.with_options(decimals: 3, searchable: false),
    fg: BigDecimalField.with_options(decimals: 3, searchable: false),
    style_code: Field::String,
    style_guide: Field::String,
    style_name: Field::String,
    batch_size: BigDecimalField.with_options(searchable: false),
    color: BigDecimalField.with_options(searchable: false),
    brewer: Field::String,
    downloads: Field::Number,
    media_main_id: Field::Number,
    cached_votes_up: Field::Number,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :media_main,
    :name,
    :user,
    :public,
    :abv,
    :ibu,
    :downloads,
    #:media_main,
    #:media,
    #:thread,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :id,
    :name,
    :user,
    :brewer,
    :description,
    #:thread,
    #:votes_for,
    :public,
    :abv,
    :ibu,
    :og,
    :fg,
    :style_code,
    :style_guide,
    :style_name,
    :batch_size,
    :color,
    :downloads,
    #:media_main_id,
    :cached_votes_up,
    :created_at,
    :updated_at,
    :media_main,
    :media,
    :beerxml,
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :description,
    :public,
    :user,
    :media_main,
    :media,
    :beerxml,
    #:thread,
    #:votes_for,
    #:abv,
    #:ibu,
    #:og,
    #:fg,
    #:style_code,
    #:style_guide,
    #:style_name,
    #:batch_size,
    #:color,
    #:brewer,
    #:downloads,
    #:media_main_id,
    #:cached_votes_up,
  ]

  # Overwrite this method to customize how recipes are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(recipe)
    recipe.name
  end
end
