module MediaParentConcern
  extend ActiveSupport::Concern

  included do
    class_attribute :_media_attributes, instance_accessor: false
    self._media_attributes = []
  end

  class_methods do
    def media_attribute(*attributes)
      self._media_attributes = attributes
    end
  end

  def remove_media_references(medium)
    media_attributes.each do |meth|
      if send(meth) == medium
        Rails.logger.debug { "Removing media assocation: #{meth}" }
        send("#{meth}=", nil)
      end
    end
    save if changed?
  end

  def has_medium?(type)
    raise MediaAttributeError.new "Media association type not available: #{type}" unless has_media_attribute?(type)
    send(media_method(type)).present?
  end

  def create_medium(file, type=nil, force=false)
    if file.kind_of? String
      file = Downloader.new(file).get
    end
    medium = media.create(file: file)
    if type.present? && (force || !has_medium?(type))
      add_medium(medium, type)
    end
    medium
  end

  def add_medium(medium, type)
    raise MediaAttributeError.new "Media association type not available: #{type}" unless has_media_attribute?(type)
    send("#{media_method(type)}=", medium)
    save!
  end

  private

  def media_method(type)
    "media_#{type.to_s.underscore}".to_sym
  end

  def has_media_attribute?(type)
    meth = media_method(type)
    media_attributes.include?(meth)
  end

  def media_attributes
    self.class._media_attributes
  end
end
