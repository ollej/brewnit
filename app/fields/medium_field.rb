require "administrate/field/base"

class MediumField < Administrate::Field::BelongsTo
  class Engine < ::Rails::Engine
    Administrate::Engine.add_javascript 'medium-field'
    Administrate::Engine.add_stylesheet 'medium-field'
  end

  def associated_class_name
    Medium.name
  end

  def associated_resource_image_options
    [''] + candidate_resources.map do |resource|
      [
        display_candidate_resource(resource),
        resource.send(primary_key),
        { 'data-img-src' => resource.url(:small) }
      ]
    end
  end

  def url(type)
    return '' if data.nil?
    data.url(type)
  end

  def to_s
    data
  end
end
