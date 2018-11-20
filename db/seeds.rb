# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

user = User.new(email: ENV['SEED_EMAIL'], full_name: ENV['SEED_NAME'],
  password: Devise.friendly_token[0, 20])

user.skip_confirmation_notification!
user.skip_reconfirmation!
user.confirm
user.save

user.make_site_admin
user.update(accepted_terms_and_conditions: true, how_did_you_hear: 'jas')

first_names = ['Tim', 'Kate', 'Watson', 'Zhang', 'Maria', 'Omar', 'Ezara']

last_names = ['Kumar', 'Huang', 'Zammit', 'Tyrel', 'Conner', 'Drizen']

100.times do |number|
  user = nil
  first_name = first_names.sample
  last_name = last_names.sample
  user = User.new(email: "#{first_name}_#{last_name}#{number}@example.com",
    full_name: "#{first_name} #{last_name}",
    preferred_name: first_name, preferred_img: nil,
    google_img: nil, dietary_requirements: 'vegetables',
    tshirt_size: 'Small', twitter: "@#{first_name}#{number}",
    mailing_list: false, challenge_sponsor_contact_place: false,
    challenge_sponsor_contact_enter: false, my_project_sponsor_contact: false,
    me_govhack_contact: (number % 2 == 0), organisation_name: nil,
    phone_number: nil, how_did_you_hear: nil,
    accepted_terms_and_conditions: false,
    password: Devise.friendly_token[0, 20])
  user.skip_confirmation_notification!
  user.skip_reconfirmation!
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

comp.update(start_time: Time.now - 5.days, end_time: Time.now - 3.days,
            peoples_choice_start: Time.now + 6.days,
            peoples_choice_end: Time.now + 1.month,
            challenge_judging_start: Time.now - 1.days,
            challenge_judging_end: Time.now + 1.month)

5.times do |time|
  comp.checkpoints.create(end_time: Time.now - time.days,
                          name: "Checkpoint #{time}",
                          max_national_challenges: 1,
                          max_regional_challenges: 1,
                          )
  comp.criteria.create(name: "Project Criterion #{time}", description: "#{time} Description
    to end all descriptions for Project Criterion.", category: PROJECT)
end

2.times do |time|
  comp.criteria.create(name: "Challenge Criterion #{time}", description: "#{time} Description
    to end all descriptions for Challenge Criterion.", category: CHALLENGE)
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

def create_event(event_type, comp, event_name, region)
  region.events.create(event_type: event_type, competition: comp,
    name: event_name, registration_type: OPEN, capacity: 50,
    email: "#{event_name}@mail.com", twitter: '@qld',
    address: "Eagle Stree, #{region.name} QLD, 4217",
    accessibility: 'Access through the stairs',
    youth_support: 'Always here.', parking: 'None, on street.',
    public_transport: 'Trains near by.', operation_hours: '9-5',
    catering: 'Lots of food, vego available.',
    place_id: 'ChIJ15yzA3lakWsRdtSXdwYk7uQ', video_id: '0Mv48ZM7gu4',
    start_time: '2018-09-10 19:20:33 +1000',
    end_time: '2018-09-10 19:20:33 +1000', published: true)
end

def fill_out_comp_event(event)
  10.times do |team_time|
    team = event.teams.create

    team.assign_leader(User.find(random_user_id))

    8.times do |time|
      team.assignments.create(title: TEAM_MEMBER, user_id: random_user_id)
    end

    team.projects.create(team_name: "#{event.name} team #{team_time}",
    description: 'Best team evaaaaaa!', project_name: "#{event.name} project #{team_time}",
    data_story: 'We will be taking a big data approach.',
    source_code_url: 'https://github.com/tenderlove/allocation_sampler',
    video_url: 'https://www.youtube.com/embed/kqcrEFkA8g0',
    homepage_url: 'https://www.govhack.org/', user: team.assignments.first.user)

    5.times do |time|
      team.team_data_sets.create(name:
        "#{team.name} dataset #{team_time + time}",
        description: 'Best dataset evaaaaaa',
        description_of_use: 'We achieved a full variance analysis',
        url: 'https://data.gov.au/dataset/wyndham-smart-bin-fill-level'
      )
    end

    Checkpoint.all.each do |checkpoint|
      team.entries.create(checkpoint: checkpoint,
        challenge_id: random_challenge_id,
        justification: 'We think we would do excellently in this challenge.')
    end
  end
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

  def random_data_set_id(region)
    @counter += 1
    random_id = @counter % region.data_sets.count
    random_id = 1 if random_id.zero?
    random_id
  end

  region.challenges.each do |challenge|
    5.times do
      challenge.challenge_data_sets.create(data_set_id: random_data_set_id(region))
    end

    3.times do
      challenge.challenge_sponsorships.create(sponsor_id: random_sponsor_id)
    end

    3.times do
      challenge.assignments.create(title: JUDGE, user_id: random_user_id)
    end
  end

  event_name = region.time_zone
  event_name ||= 'Australia'

  EVENT_TYPES.each do |event_type|

    next if event_name == 'Australia' && event_type == COMPETITION_EVENT

    event = create_event(event_type, comp, event_name, region)

    EventPartnership.create(event: event, sponsor_id: random_sponsor_id)

    event.assignments.create(user_id: random_user_id, title: EVENT_HOST)

    event.assignments.create(user_id: random_user_id, title: EVENT_SUPPORT)

    event.assignments.create(user_id: random_user_id, title: EVENT_SUPPORT)

    Assignment.where(title: PARTICIPANT).take(20).each do |particiant|
      event.registrations.create(status: ATTENDING, assignment: particiant)
    end

    if event_type == COMPETITION_EVENT
      fill_out_comp_event(event)
      event = create_event(event_type, comp, "Remote #{region.name}", region)
      fill_out_comp_event(event)
    end
  end
end

comp.teams.all.each do |team|
  Assignment.where(title: PARTICIPANT).take(20).each do |assignment|
    scorecard = Scorecard.create(judgeable: team, assignment: assignment, included: (assignment.id % 5 != 0))
    comp.criteria.where(category: PROJECT).each do |criterion|
      score = Random.rand(11)
      score = nil if score.zero?
      Judgment.create(criterion: criterion, scorecard: scorecard, score: score)
    end
  end
end
