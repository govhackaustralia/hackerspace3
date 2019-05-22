class UserOrder < ApplicationRecord
  belongs_to :bulk_mail

  has_many :correspondences, as: :orderable, dependent: :destroy

  # Returns the registrations of a user_order given it's request type.
  def registrations(event)
    case request_type
    when INVITED
      event.registrations.where status: INVITED
    when ATTENDING
      event.registrations.where status: ATTENDING
    when INVITED_AND_ATTENDING
      event.registrations.where status: [INVITED, ATTENDING]
    else
      []
    end
  end

  # Prepare and send e-mails for user orders.
  def process(registration, bulk_mail)
    return unless registration.user.me_govhack_contact

    email_body = BulkMail.correspondence_body bulk_mail.body, registration.user
    correspondence = correspondences.create(user: registration.user, body: email_body, status: PENDING)
    BulkMailer.participant_email(self, correspondence, registration.user).deliver_now unless %w[development test].include? ENV['RAILS_ENV']
    correspondence.update status: SENT
  end
end
