class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_FROM_EMAIL']
  helper(ApplicationHelper)
  layout 'mailer'
end
