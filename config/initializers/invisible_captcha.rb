InvisibleCaptcha.setup do |config|
  config.honeypots           = [:additional_information, :contact_options, :custom, :extra_details, :leave_blank, :optional_data, :other, :phone, :preferred_contact, :secondary_input, :special_instructions, :terms_and_conditions, :web_site]
  config.visual_honeypots    = ENV['HONEYPOTS_SHOW'].to_s.downcase == 'true' || false
  config.timestamp_enabled   = ENV['HONEYPOTS_TIMEOUT_ENABLED'] || false
  config.timestamp_threshold = ENV['HONEYPOTS_TIMEOUT'].to_i || 2
  # config.timestamp_enabled   = true
  # config.injectable_styles   = false
  # config.spinner_enabled     = true

  # Leave these unset if you want to use I18n (see below)
  # config.sentence_for_humans     = 'If you are a human, ignore this field'
  # config.timestamp_error_message = 'Sorry, that was too quick! Please resubmit.'
end
