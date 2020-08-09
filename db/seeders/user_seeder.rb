require_relative 'seeder'

class UserSeeder < Seeder
  def self.create_tester
    tester = User.new(
      email: admin_email,
      full_name: admin_name,
      password: 'password',
      password_confirmation: 'password'
    )
    tester.skip_confirmation_notification!
    tester.skip_reconfirmation!
    tester.confirm
    tester.save
    tester.update!(
      accepted_terms_and_conditions: true,
      how_did_you_hear: 'jas'
    )
  end

  def self.create_admin competition
    user = User.find_by_email(admin_email)
    user.make_site_admin competition, user.holder_for(competition)
  end

  def self.create_users size
    size.times do |number|
      user = nil
      first_name = Faker::Name.first_name
      last_name = Faker::Name.last_name
      user = User.new(
        email: "#{first_name}_#{last_name}#{number}@example.com",
        full_name: "#{first_name} #{last_name}",
        preferred_name: first_name,
        preferred_img: nil,
        google_img: nil,
        dietary_requirements: ("No #{Faker::Food.dish}" if number % 3 == 0),
        tshirt_size: 'Small',
        slack: "@#{first_name}#{Faker::Food.spice.camelize(:lower)}",
        mailing_list: random_boolean,
        challenge_sponsor_contact_place: random_boolean,
        challenge_sponsor_contact_enter: random_boolean,
        my_project_sponsor_contact: random_boolean,
        me_govhack_contact: random_boolean,
        organisation_name: (Faker::Company.name if number % 5 == 0),
        phone_number: nil,
        how_did_you_hear: nil,
        accepted_terms_and_conditions: nil,
        accepted_code_of_conduct: (Time.now unless number % 10 == 0),
        password: Devise.friendly_token[0, 20],
        request_not_photographed: random_boolean,
        data_cruncher: random_boolean,
        coder: random_boolean,
        creative: random_boolean,
        facilitator: random_boolean,
        registration_type: USER_REGISTRATION_TYPES.sample,
        region: User.regions.keys.sample,
        under_18: random_boolean
      )

      if user.registration_type == YOUTH_COMPETITOR
        user.parent_guardian = Faker::Name.name
      end

      user.skip_confirmation_notification!
      user.skip_reconfirmation!
      user.confirm if number % 20 == 0
      user.save!

      Profile.create(
        user: user,
        age: Profile.ages.keys.sample,
        gender: Faker::Gender.type,
        first_peoples: Profile.first_peoples.keys.sample,
        disability: Profile.disabilities.keys.sample,
        education: Profile.educations.keys.sample,
        employment: Profile.employments.keys.sample,
        postcode: Faker::Address.postcode,
        skill_list: random_skills,
        interest_list: random_interests,
        twitter: "@#{user.preferred_name}#{number}",
        github: "@#{user.preferred_name}#{number}",
        team_status: Profile.team_statuses.keys.sample,
        website: "www.#{user.preferred_name}.com",
        linkedin: "#{user.preferred_name}@linkedin",
        description: Faker::Lorem.paragraph
      )
    end
  end

  def self.create_favourites(comp)
    teams = comp.teams.where.not project_id: nil
    return unless teams.any?

    comp.assignments.event_assignments.each do |event_assignment|
      6.times do
        event_assignment.favourites.create(
          team: teams.sample,
          holder_id: event_assignment.holder_id
        )
      end
    end
  end
end
