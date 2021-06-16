gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'], symbolize_keys: true)
gibbon.lists(ENV['MAILCHIMP_LIST_ID']).members.create(body: {email_address: "luke.cassar@hey.com", status: "subscribed", merge_fields: {FNAME: "Luke", LNAME: "Cassar Hey"}})
