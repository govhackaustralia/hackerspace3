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
  user.save
end

comp = Competition.current

comp.assignments.create(user: User.find(2), title: MANAGEMENT_TEAM)

comp.assignments.create(user: User.find(3), title: MANAGEMENT_TEAM)

comp.assignments.create(user: User.find(4), title: MANAGEMENT_TEAM)

comp.assignments.create(user: User.find(5), title: MANAGEMENT_TEAM)

comp.assignments.create(user: User.find(6), title: COMPETITION_DIRECTOR)

comp.assignments.create(user: User.find(7), title: SPONSORSHIP_DIRECTOR)

10.times do |time|
  comp.assignments.create(user: User.find(time + 1), title: VOLUNTEER)
end

20.times do |time|
  comp.assignments.create(user: User.find(time + 2), title: VIP)
end

20.times do |time|
  comp.assignments.create(user: User.find(time + 3), title: PARTICIPANT)
end

20.times do |time|
  comp.sponsors.create(name: "Vandelay  Industries #{time}", description: "Worldwide leader in latex products", website: 'www.vandel.com', created_at: "2018-07-26 23:01:28", updated_at: "2018-07-26 23:01:28")
end

10.times do |time|
  comp.sponsorship_types.create(name: "Tier #{time + 1}", order: time + 1)
end

Region.create(name: 'New South Wales', time_zone: 'Sydney', parent_id: Region.root.id)

Region.create(name: 'Victoria', time_zone: 'Melbourne', parent_id: Region.root.id)

Region.create(name: 'South Australia', time_zone: 'Adelaide', parent_id: Region.root.id)

Region.create(name: 'Western Australia', time_zone: 'Perth', parent_id: Region.root.id)

Region.create(name: 'Tasmania', time_zone: 'Hobart', parent_id: Region.root.id)

Region.create(name: 'ACT', time_zone: 'Canberra', parent_id: Region.root.id)

Region.create(name: 'Queensland', time_zone: 'Brisbane', parent_id: Region.root.id)

counter = 1

Region.all.each do |region|

  region.assignments.create(user: User.find(1+counter), title: REGION_DIRECTOR)

  region.assignments.create(user: User.find(2+counter), title: REGION_SUPPORT)

  region.assignments.create(user: User.find(3+counter), title: REGION_SUPPORT)

  region.assignments.create(user: User.find(4+counter), title: REGION_SUPPORT)

  3.times do |time|
    region.sponsorships.create(sponsor: Sponsor.find((counter + time) % Sponsor.count),
    sponsorship_type: SponsorshipType.find(counter % SponsorshipType.count))
  end

  opening = region.events.create(competition: comp, name: 'Brisbane',
  registration_type: OPEN, capacity: 50, email: "#{region.name}@mail.com", twitter: '@qld',
  address: "Eagle Stree, #{region.name} QLD, 4217", accessibility: 'Access through the stairs',
  youth_support: 'Always here.', parking: 'None, on street.',
  public_transport: 'Trains near by.', operation_hours: '9-5',
  catering: 'Lots of food, vego available.', lat: -27.4697707,
  long: 153.02512350000006, video_url: 'https://www.youtube.com/watch?v=0Mv48ZM7gu4',
  start_time: '2018-09-10 19:20:33 +1000', end_time: '2018-09-10 19:20:33 +1000',
  category_type: STATE_CONNECTIONS)

  EventPartner.create(event: opening, sponsor: Sponsor.find(counter))

  opening.assignments.create(user: User.find(5+counter), title: EVENT_HOST)

  opening.assignments.create(user: User.find(6+counter), title: EVENT_SUPPORT)

  opening.assignments.create(user: User.find(7+counter), title: EVENT_SUPPORT)

  Assignment.where(title: PARTICIPANT).take(10).each do |particiant|
    opening.registrations.create(status: ATTENDING, assignment: particiant)
  end

  Assignment.where(title: VIP).take(10).each do |vip|
    opening.registrations.create(status: ATTENDING, assignment: vip)
  end

  counter += 1
end
