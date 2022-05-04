class MailchimpUpdateJob < ApplicationJob
  queue_as :default

  def perform(*users)
    return unless mailchimp_env_variables_set?

    users.flatten.each { |user| upsert_to_mailchimp user }
  end

  private

  def mailchimp_env_variables_set?
    [ENV.fetch('MAILCHIMP_API_KEY', nil), ENV.fetch('MAILCHIMP_LIST_ID', nil)].exclude? nil
  end

  def upsert_to_mailchimp(user)
    return unless user.confirmed?

    response = gibbon.lists(ENV.fetch('MAILCHIMP_LIST_ID', nil))
      .members(Digest::MD5.hexdigest(user.email))
      .upsert(user_params(user))

    puts "Created/Update Mailchimp User: #{response.body.slice(*response_params)}"
  end

  def user_params(user)
    {
      body: {
        email_address: user.email,
        status: status_label(user),
        merge_fields: {
          FNAME: user.display_name
        }
      }
    }
  end

  def gibbon
    @gibbon ||= Gibbon::Request.new(api_key: ENV.fetch('MAILCHIMP_API_KEY', nil), symbolize_keys: true)
  end

  def status_label(user)
    return 'subscribed' if user.mailing_list

    'unsubscribed'
  end

  def response_params
    %i[id email_address full_name status]
  end
end
