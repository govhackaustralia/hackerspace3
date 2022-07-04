# Preview all emails at http://localhost:3000/rails/mailers/registration_mailer
class RegistrationMailerPreview < ActionMailer::Preview
  def attendance_email
    RegistrationMailer.attendance_email(registrations(:attending))
  end
end
