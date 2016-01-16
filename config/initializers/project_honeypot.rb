require 'project_honeypot'

ProjectHoneypot.configure do
  @api_key = Rails.application.secrets.project_honeypot_key
  @score = 42
  @last_activity = 10
  @offenses = [:comment_spammer, :suspicious, :harvester]
end
