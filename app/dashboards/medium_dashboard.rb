require "administrate/base_dashboard"

class MediumDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    parent: Field::Polymorphic,
    id: Field::Number,
    file: MediumField, #Field::String,
    caption: Field::String,
    sorting: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    file_file_name: Field::String,
    file_content_type: Field::String,
    file_file_size: Field::Number,
    file_updated_at: Field::DateTime,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :file,
    :parent,
    :id,
    :caption,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :parent,
    :id,
    :file,
    :caption,
    :sorting,
    :created_at,
    :updated_at,
    :file_file_name,
    :file_content_type,
    :file_file_size,
    :file_updated_at,
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :parent,
    :file,
    :caption,
    :sorting,
    :file_file_name,
    :file_content_type,
    :file_file_size,
    :file_updated_at,
  ]

  # Overwrite this method to customize how media are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(medium)
  #   "Medium ##{medium.id}"
  # end
end
