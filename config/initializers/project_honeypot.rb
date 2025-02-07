require 'project-honeypot'

ProjectHoneypot.configure do |config|
  config.api_key = Rails.configuration.secrets.project_honeypot_key
  config.score_tolerance = 42
  config.last_activity_tolerance = 10
  #@offenses = [:comment_spammer, :suspicious, :harvester]
end
