class BulkMailer < ApplicationMailer
  def participant_email(bulk_mail, correspondence, to_user)
    @body = correspondence.body
    mail(to: to_user.email, from: bulk_mail.from_email, subject: bulk_mail.subject)
  end
end
