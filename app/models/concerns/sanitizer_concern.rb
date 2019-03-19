module SanitizerConcern
  extend ActiveSupport::Concern

  ALLOWED_TAGS = %w(h1 h2 h3 b i strong em br p small del strike s ins u sub sup mark hr q blockquote pre ul ol li span)
  ALLOWED_ATTRIBUTES = %w(spellcheck)

  included do
    before_validation :sanitize_fields
    class_attribute :fields_to_sanitize
  end

  class_methods do
    def sanitized_fields(*fields)
      if self.fields_to_sanitize.nil?
        self.fields_to_sanitize = fields
      else
        self.fields_to_sanitize += fields
      end
    end
  end

  def sanitize_fields
    self.class.fields_to_sanitize.each do |field|
      if send(field).present? && send("#{field}_changed?")
        send("#{field}=", sanitize_field(field))
      end
    end
  end

  def sanitize_field(field)
    sanitizer.sanitize(send(field))
  end

  def sanitizer
    @sanitizer ||= Sanitizer.new(tags: ALLOWED_TAGS, attributes: ALLOWED_ATTRIBUTES)
  end
end
