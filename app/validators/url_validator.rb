class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t(:'activerecord.errors.messages.invalid_url')) unless url_valid?(value)
  end

  def url_valid?(url)
    url = URI.parse(url) rescue false
    url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
  end
end

