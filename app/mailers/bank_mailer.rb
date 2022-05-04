class BankMailer < ApplicationMailer
  def notify_finance(user)
    @user = user
    mail(to: ENV.fetch('FINANCE_EMAIL', nil), subject: "Participant #{user.full_name} has Entered Bank Details")
  end
end
