# frozen_string_literal: true

class UserRegistrationReport
  USER_COLUMNS = %w[
    id
    email
    full_name
    preferred_name
    region
    dietary_requirements
    tshirt_size
    slack
    mailing_list
    challenge_sponsor_contact_place
    challenge_sponsor_contact_enter
    my_project_sponsor_contact
    me_govhack_contact phone_number
    how_did_you_hear accepted_terms_and_conditions
    registration_type parent_guardian
    request_not_photographed
    data_cruncher
    coder
    creative
    facilitator
  ].freeze

  def self.report(competition)
    CSV.generate do |csv|
      csv << (USER_COLUMNS + ['events'])
      all_users = User.all.preload(:participating_events)
      sorted_users = all_users.sort_by(&:id).reverse
      sorted_users.each do |user|
        event_names = user.participating_events.competition(competition).pluck(:name)
        csv << (user.attributes.values_at(*USER_COLUMNS) << event_names)
      end
    end
  end
end
