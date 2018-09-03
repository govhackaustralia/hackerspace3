# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

user = User.new(email: ENV['SEED_EMAIL'], full_name: ENV['SEED_NAME'],
  password: Devise.friendly_token[0, 20])

user.skip_confirmation_notification!
user.save

user.make_site_admin

100.times do |number|
  user = nil
  if number % 2 == 0
    user = User.new(email: "tommo#{number}@example.com", full_name: "Tommo#{number}",
      preferred_name: "Tom#{number}", preferred_img: nil, google_img: nil,
      dietary_requirements: 'vegetables', tshirt_size: 'Small',
      twitter: "@tommo#{number}", mailing_list: false, challenge_sponsor_contact_place: false,
      challenge_sponsor_contact_enter: false, my_project_sponsor_contact: false,
      me_govhack_contact: false, created_at: "2018-07-24 21:32:29",
      updated_at: "2018-07-24 21:32:29", organisation_name: nil,
      phone_number: nil, how_did_you_hear: nil,
      accepted_terms_and_conditions: false,
      password: Devise.friendly_token[0, 20])
  else
    user = User.new(email: "sally#{number}@email.com", full_name: "Sandra Key#{number}", preferred_name: "Sally#{number}",
      preferred_img: nil, google_img: nil, dietary_requirements: nil,
      tshirt_size: 'Large', twitter: "@sally#{number}", mailing_list: false,
      challenge_sponsor_contact_place: false, challenge_sponsor_contact_enter: false,
      my_project_sponsor_contact: false, me_govhack_contact: false,
      created_at: "2018-07-24 21:36:57", updated_at: "2018-07-24 21:36:57",
      organisation_name: nil, phone_number: nil, how_did_you_hear: nil,
      accepted_terms_and_conditions: false, password: Devise.friendly_token[0, 20])
  end
  user.skip_confirmation_notification!
  user.confirm
  user.save
end

@counter = 0
def random_user_id
  @counter += 1
  random_id = @counter % User.count
  random_id = 1 if random_id.zero?
  random_id
end

comp = Competition.current

comp.update(start_time: Time.now + 3.days, end_time: Time.now + 5.days)

5.times do |time|
  comp.checkpoints.create(end_time: Time.now + time.days,
                          name: "Checkpoint #{time}",
                          max_national_challenges: 1,
                          max_regional_challenges: 1)
end

comp.assignments.create(user_id: random_user_id, title: MANAGEMENT_TEAM)

comp.assignments.create(user_id: random_user_id, title: MANAGEMENT_TEAM)

comp.assignments.create(user_id: random_user_id, title: MANAGEMENT_TEAM)

comp.assignments.create(user_id: random_user_id, title: MANAGEMENT_TEAM)

comp.assignments.create(user_id: random_user_id, title: COMPETITION_DIRECTOR)

comp.assignments.create(user_id: random_user_id, title: SPONSORSHIP_DIRECTOR)

10.times do |time|
  comp.assignments.create(user_id: random_user_id, title: VOLUNTEER)
end

20.times do |time|
  comp.assignments.create(user_id: random_user_id, title: PARTICIPANT)
end

20.times do |time|
  comp.sponsors.create(name: "Vandelay  Industries #{time}",
    description: "Worldwide leader in latex products",
    website: 'http://seinfeld.wikia.com/wiki/Vandelay_Industries',
    created_at: "2018-07-26 23:01:28",
    updated_at: "2018-07-26 23:01:28")
end

def random_sponsor_id
  @counter += 1
  random_id = @counter % Sponsor.count
  random_id = 1 if random_id.zero?
  random_id
end

10.times do |time|
  comp.sponsorship_types.create(name: "Tier #{time + 1}", order: time + 1)
end

def random_sponsorship_type_id
  @counter += 1
  random_id = @counter % SponsorshipType.count
  random_id = 1 if random_id.zero?
  random_id
end

def random_challenge_id
  @counter += 1
  random_id = @counter % Challenge.count
  random_id = 1 if random_id.zero?
  random_id
end

Region.create(name: 'New South Wales', time_zone: 'Sydney', parent_id: Region.root.id)

Region.create(name: 'Victoria', time_zone: 'Melbourne', parent_id: Region.root.id)

Region.create(name: 'South Australia', time_zone: 'Adelaide', parent_id: Region.root.id)

Region.create(name: 'Western Australia', time_zone: 'Perth', parent_id: Region.root.id)

Region.create(name: 'Tasmania', time_zone: 'Hobart', parent_id: Region.root.id)

Region.create(name: 'ACT', time_zone: 'Canberra', parent_id: Region.root.id)

Region.create(name: 'Queensland', time_zone: 'Brisbane', parent_id: Region.root.id)

Region.all.each do |region|

  region.assignments.create(user_id: random_user_id, title: REGION_DIRECTOR)

  region.assignments.create(user_id: random_user_id, title: REGION_SUPPORT)

  region.assignments.create(user_id: random_user_id, title: REGION_SUPPORT)

  region.assignments.create(user_id: random_user_id, title: REGION_SUPPORT)

  3.times do |time|
    region.sponsorships.create(sponsor_id: random_sponsor_id,
    sponsorship_type_id: random_sponsorship_type_id)
  end

  5.times do |time|
    region.challenges.create(competition: comp,
      name: "#{region.name} Challenge #{time}",
      short_desc: 'A really good challenge', approved: true,
      long_desc: 'This challenge incorporates multiple data sets.',
      eligibility: 'You must be this tall to go on this ride.',
      video_url: 'https://www.youtube.com/embed/kqcrEFkA8g0')
  end

  10.times do |time|
    region.data_sets.create(competition: comp,
      name: "#{region.name} Data Set #{time}",
      url: 'https://data.gov.au/dataset/wyndham-smart-bin-fill-level',
      description: 'Random dataset that was taken from data.gov.')
  end

  event_name = region.time_zone
  event_name ||= 'Australia'

  EVENT_TYPES.each do |event_type|

    event = region.events.create(event_type: event_type, competition: comp,
      name: event_name, registration_type: OPEN, capacity: 50,
      email: "#{event_name}@mail.com", twitter: '@qld',
      address: "Eagle Stree, #{region.name} QLD, 4217",
      accessibility: 'Access through the stairs',
      youth_support: 'Always here.', parking: 'None, on street.',
      public_transport: 'Trains near by.', operation_hours: '9-5',
      catering: 'Lots of food, vego available.',
      place_id: 'ChIJ15yzA3lakWsRdtSXdwYk7uQ', video_id: '0Mv48ZM7gu4',
      start_time: '2018-09-10 19:20:33 +1000',
      end_time: '2018-09-10 19:20:33 +1000')

    EventPartnership.create(event: event, sponsor_id: random_sponsor_id)

    event.assignments.create(user_id: random_user_id, title: EVENT_HOST)

    event.assignments.create(user_id: random_user_id, title: EVENT_SUPPORT)

    event.assignments.create(user_id: random_user_id, title: EVENT_SUPPORT)

    Assignment.where(title: PARTICIPANT).take(10).each do |particiant|
      event.registrations.create(status: ATTENDING, assignment: particiant)
    end

    Assignment.where(title: VIP).take(10).each do |vip|
      event.registrations.create(status: ATTENDING, assignment: vip)
    end

    if event_type == COMPETITION_EVENT
      10.times do |team_time|
        team = event.teams.create(published: true)

        team.assign_leader(User.find(random_user_id))

        8.times do |time|
          team.assignments.create(title: TEAM_MEMBER, user_id: random_user_id)
        end

        team.projects.create(team_name: "#{event.name} team #{team_time}",
        description: 'Best team evaaaaaa!',
        data_story: 'We will be taking a big data approach.',
        source_code_url: 'https://github.com/tenderlove/allocation_sampler',
        video_url: 'https://www.youtube.com/embed/kqcrEFkA8g0',
        homepage_url: 'https://www.govhack.org/', user: team.assignments.first.user)

        5.times do |time|
          team.team_data_sets.create(name:
            "#{team.name} dataset #{team_time + time}",
            description: 'Best dataset evaaaaaa',
            description_of_use: 'We achieved a full variance analysis',
            url: 'https://data.gov.au/dataset/city-of-gold-coast-road-closures'
          )
        end

        Checkpoint.all.each do |checkpoint|
          team.entries.create(checkpoint: checkpoint,
            challenge_id: random_challenge_id, eligible: (team.id % 2 == 0),
            justification: 'We think we would do excellently in this challenge.')
        end
      end
    end
  end
end
