require 'pushover'

Pushover.configure do |config|
  config.user = Rails.configuration.secrets.pushover_user
  config.token = Rails.configuration.secrets.pushover_token
end
