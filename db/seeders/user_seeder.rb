require_relative 'seeder'

class UserSeeder < Seeder
  def self.create_tester
    tester = User.new(
      email: ENV['SEED_EMAIL'],
      full_name: ENV['SEED_NAME'],
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
    User.find_by_email(ENV['SEED_EMAIL']).make_site_admin competition
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
        twitter: "@#{first_name}#{number}",
        slack: "@#{first_name}#{Faker::Food.spice.camelize(:lower)}", 
        mailing_list: random_boolean,
        challenge_sponsor_contact_place: random_boolean,
        challenge_sponsor_contact_enter: random_boolean,
        my_project_sponsor_contact: random_boolean,
        me_govhack_contact: random_boolean,
        organisation_name: (Faker::Company.name if number % 5 == 0),
        phone_number: nil,
        how_did_you_hear: nil,
        accepted_terms_and_conditions: false,
        password: Devise.friendly_token[0, 20],
        request_not_photographed: random_boolean,
        aws_credits_requested: number % 4 == 0,
        data_cruncher: random_boolean,
        coder: random_boolean,
        creative: random_boolean,
        facilitator: random_boolean,
        registration_type: USER_REGISTRATION_TYPES.sample
      )

      if user.registration_type == YOUTH_COMPETITOR
        user.parent_guardian = Faker::Name.name
      end

      user.skip_confirmation_notification!
      user.skip_reconfirmation!
      user.confirm if number % 20 == 0
      user.save
    end
  end

  def self.create_favourites(comp)
    teams = comp.teams
    comp.assignments.event_assignments.each do |event_assignment|
      6.times do
        event_assignment.favourites.create(
          team: teams.sample
        )
      end
    end
  end
end
