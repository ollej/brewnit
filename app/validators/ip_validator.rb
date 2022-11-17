class IpValidator < ActiveModel::Validator
  BLOCKED_COUNTRIES = ENV.fetch('SPAM_COUNTRIES', '').upcase.split(' ')

  def validate(record)
    ip = record.last_sign_in_ip 
    geocode = Geocoder.search(ip)&.first

    if BLOCKED_COUNTRIES.include? geocode&.country_code&.upcase
      record.errors.add :base, "Spam registration suspected"
    else
      record.geocode = geocode.data
    end
  end
end

