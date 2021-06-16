class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_FROM_EMAIL'] || 'notifications@hackerspace.com'
  helper(ApplicationHelper)
  layout 'mailer'
end
