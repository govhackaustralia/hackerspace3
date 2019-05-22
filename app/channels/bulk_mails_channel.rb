class BulkMailsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "bulk_mails_#{params['bulk_mail_id']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def process_mail(data)
    bulk_mail = BulkMail.find data['bulk_mail_id']
    bulk_mail.update status: PROCESS
    BulkMailOutJob.perform bulk_mail
  end
end
