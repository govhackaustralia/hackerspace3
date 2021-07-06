class MailchimpUpdateJob < ApplicationJob
  queue_as :default

  def perform(*users)
    return if ENV['MAILCHIMP_API_KEY'].nil? || ENV['MAILCHIMP_LIST_ID'].nil?

    users.flatten.each do |user|
      next unless user.confirmed?

      response = gibbon.lists(ENV['MAILCHIMP_LIST_ID'])
        .members(Digest::MD5.hexdigest(user.email))
        .upsert(body:
          {
            email_address: user.email,
            status: status_label(user),
            merge_fields: {
              FNAME: user.display_name
            }
          }
        )

        puts "Created/Update Mailchimp User: #{response.body.slice(:id, :email_address, :full_name, :status)}"
    end
  end

  private

  def gibbon
    @gibbon ||= Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'], symbolize_keys: true)
  end

  def status_label(user)
    return 'subscribed' if user.mailing_list

    'unsubscribed'
  end
end
