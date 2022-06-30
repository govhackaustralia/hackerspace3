# Preview all emails at http://localhost:3000/rails/mailers/badge_mailer
class BadgeMailerPreview < ActionMailer::Preview
  def notify_badge_awarded
    BadgeMailer.notify_badge_awarded(users(:one), Badge.first)
  end
end
