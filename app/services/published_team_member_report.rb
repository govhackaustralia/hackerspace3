require 'csv'

class PublishedTeamMemberReport
  attr_accessor :competition

  HEADER_NAMES = %w[
    id
    email
    full_name
    preferred_name
    dietary_requirements
    tshirt_size
    twitter
    slack
    mailing_list
    challenge_sponsor_contact_place
    challenge_sponsor_contact_enter
    my_project_sponsor_contact
    me_govhack_contact
    phone_number
    how_did_you_hear
    accepted_terms_and_conditions
    registration_type
    parent_guardian
    request_not_photographed
    data_cruncher
    coder
    creative
    facilitator
  ].freeze

  def initialize(competition)
    @competition = competition
  end

  def to_csv
    CSV.generate do |csv|
      csv << HEADER_NAMES
      users.each do |user|
        csv << user.attributes.values_at(*HEADER_NAMES)
      end
    end
  end

  private

  def users
    # ENHANCEMENT: Create a scope for the below.
    User.where(
      id: competition.competition_assignments.team_participants.where(
        assignable: competition.teams.published
      ).pluck(:user_id).uniq
    )
  end
end
