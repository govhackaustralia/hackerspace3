class RegistrationMailer < ApplicationMailer

  def attendance_email(registration)
    @registration = registration
    @assignment = registration.assignment
    @event = registration.event
    @region = @event.region
    @user = @assignment.user
    mail(to: @user.email, subject: "A space at #{@event.name} #{@region.name} has opened up.")
  end
end
