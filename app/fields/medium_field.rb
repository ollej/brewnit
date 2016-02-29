require "administrate/field/base"

class MediumField < Administrate::Field::Base
  def url(type)
    return if data.nil?
    if data.respond_to? :file
      data.file.url(type)
    else
      data.url(type)
    end
  end

  def to_s
    data
  end
end
