class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('DEFAULT_FROM_EMAIL', nil) || 'notifications@hackerspace.com'
  helper(ApplicationHelper)
  layout 'mailer'
end
