# Preview all emails at http://localhost:3000/rails/mailers/bulk_mailer
class BulkMailerPreview < ActionMailer::Preview
  def participant_email
    BulkMailer.participant_email(BulkMail.first, Correspondence.first, User.first)
  end
end
