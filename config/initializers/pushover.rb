require 'pushover'

Pushover.configure do |config|
  config.user = Rails.application.secrets.pushover_user
  config.token = Rails.application.secrets.pushover_token
end
