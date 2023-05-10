# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/devise_mailer_preview.rb
class Devise::DeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    Devise::Mailer.confirmation_instructions(users(:one), 'faketoken')
  end

  def email_changed
    Devise::Mailer.email_changed(users(:one), {})
  end

  def password_change
    Devise::Mailer.password_change(users(:one), {})
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(users(:one), 'faketoken')
  end

  def unlock_instructions
    Devise::Mailer.unlock_instructions(users(:one), 'faketoken')
  end
end
