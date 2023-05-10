# frozen_string_literal: true

class BadgeMailer < ApplicationMailer
  def notify_badge_awarded(user, badge)
    @user = user
    @profile = user.profile
    @badge = badge
    mail(to: @user.email, subject: "You've been awarded the #{@badge.name} badge!")
  end
end
