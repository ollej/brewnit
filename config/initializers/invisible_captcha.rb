InvisibleCaptcha.setup do |config|
  # config.honeypots           << ['more', 'fake', 'attribute', 'names']
  # config.visual_honeypots    = false
  config.visual_honeypots = false
  # config.timestamp_threshold = 4
  config.timestamp_threshold = 1
  # config.timestamp_enabled   = true
  # config.injectable_styles   = false

  # Leave these unset if you want to use I18n (see below)
  # config.sentence_for_humans     = 'If you are a human, ignore this field'
  # config.timestamp_error_message = 'Sorry, that was too quick! Please resubmit.'
  config.sentence_for_humans = "Fyll inte i detta fält"
  config.timestamp_error_message = 'Du postade formuläret för snabbt'
end
