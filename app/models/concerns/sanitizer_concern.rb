module SanitizerConcern
  extend ActiveSupport::Concern

  ALLOWED_TAGS = %w(b i strong em br p small del strike s ins u sub sup mark hr q)

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
    sanitize_string(send(field))
  end

  def sanitize_string(string)
    Rails::Html::WhiteListSanitizer.new.sanitize(string, tags: ALLOWED_TAGS)
  end
end