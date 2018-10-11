class ApplicationMailer < ActionMailer::Base
  default from: ENV['DEFAULT_FROM_EMAIL']
  add_template_helper(ApplicationHelper)
  layout 'mailer'
end
