require 'MailchimpMarketing'

# Run on command line with $ rails runner mailchimp.rb

begin
  client = MailchimpMarketing::Client.new
  client.set_config({ api_key: ENV['MAILCHIMP_API_KEY'], server: ENV['MAILCHIMP_SERVER_PREFIX'] })

  response =
    client.lists.add_list_member(
      ENV['MAILCHIMP_LIST_ID'],
      {
        'email_address' => 'Kelley.Haley28@hotmail.com',
        'status' => 'subscribed',
        'merge_fields' => {
          'FNAME' => 'Kelley',
          'LNAME' => 'Haley'
        }
      }
    )
  p response
rescue MailchimpMarketing::ApiError => e
  puts "Error: #{e}"
end
