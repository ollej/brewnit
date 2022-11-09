class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value =~ /@(yandex\.com|.*\.ru|.*\.lolekemail\.net|super300.xyz)\z/i
      record.errors.add attribute, (options[:message] || "is not a valid email address")
    end
  end
end

