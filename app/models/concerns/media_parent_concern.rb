module MediaParentConcern
  extend ActiveSupport::Concern

  module ClassMethods
    def media_associations
      self.reflect_on_all_associations(:belongs_to).map(&:name).select { |a| a.to_s.start_with? 'media_' }
    end

    def has_association(type)
      Rails.logger.debug { self.media_associations }
      meth = self.media_method(type)
      self.media_associations.include?(meth)
    end

    def media_method(type)
      "media_#{type.underscore}".to_sym
    end

  end

  def remove_media_references(medium)
    self.class.media_associations.each do |meth|
      if send(meth) == medium
        Rails.logger.debug { "Removing media assocation: #{meth}" }
        send("#{meth}=", nil)
      end
    end
    save if changed?
  end

  def add_medium(medium, type)
    raise MediaAssociationError.new "Media association type not available: #{type}" unless self.class.has_association(type)
    self.send("#{self.class.media_method(type)}=", medium)
    self.save!
  end

end
