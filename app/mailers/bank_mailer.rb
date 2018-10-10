class BankMailer < ApplicationMailer
  def notify_finance(user)
    @user = user
    mail(to: ENV['FINANCE_EMAIL'], subject: "Participant #{user.full_name} has Entered Bank Details")
  end
end
