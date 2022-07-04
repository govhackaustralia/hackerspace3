# Preview all emails at http://localhost:3000/rails/mailers/bank_mailer
class BankMailerPreview < ActionMailer::Preview
  def notify_finance
    BankMailer.notify_finance(users(:one))
  end
end
