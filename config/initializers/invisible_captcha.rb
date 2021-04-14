InvisibleCaptcha.setup do |config|
  config.timestamp_enabled = !Rails.env.test?
  # config.honeypots           << ['more', 'fake', 'attribute', 'names']
  # config.visual_honeypots    = false
  # config.timestamp_threshold = 2
  # config.timestamp_enabled   = true
  # config.injectable_styles   = false
  # config.spinner_enabled     = true

  # Leave these unset if you want to use I18n (see below)
  # config.sentence_for_humans     = 'If you are a human, ignore this field'
  # config.timestamp_error_message = 'Sorry, that was too quick! Please resubmit.'
end
