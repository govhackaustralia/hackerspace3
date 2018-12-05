# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

# To set to a particular a point in the competition run db:setup with the below
# STAGE variables set.

# PRE_CONNECTION - For before the connection events.
# MID_COMPETITION - For mid way through the competition.
# POST_COMPETITION - For After the competition.

# Example $ rails db:setup STAGE=PRE_CONNECTION

# TODO: BulkMail Seeds for Regions
# TODO: Admin needs to be apart of a few teams.

admin = User.new(email: ENV['SEED_EMAIL'], full_name: ENV['SEED_NAME'],
  password: Devise.friendly_token[0, 20])

admin.skip_confirmation_notification!
admin.skip_reconfirmation!
admin.confirm
admin.save
admin.make_site_admin
admin.update(accepted_terms_and_conditions: true, how_did_you_hear: 'jas')

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
  user.event_assignment
end

@counter = 0

def random_model_id(model)
  random_id = (@counter += 1) % model.count
  random_id.zero? ? 1 : random_id
end

if ENV['STAGE'] == 'PRE_CONNECTION'
  comp_start = Time.now + 2.months
elsif ENV['STAGE'] == 'MID_COMPETITION'
  comp_start = Time.now - 1.days
elsif ENV['STAGE'] == 'POST_COMPETITION'
  comp_start = Time.now - 4.days
else
  comp_start = Time.now
end

comp_end = comp_start + 3.days
peoples_start = comp_start + 1.weeks
peoples_end = peoples_start + 2.weeks
judging_start = comp_start + 1.weeks
judging_end = judging_start + 3.weeks

comp = Competition.current

comp.update(start_time: comp_start, end_time: comp_end,
            peoples_choice_start: peoples_start,
            peoples_choice_end: peoples_end,
            challenge_judging_start: judging_start,
            challenge_judging_end: judging_end)

5.times do |time|
  comp.checkpoints.create(end_time: comp_start + (time* 6).days,
                          name: "Checkpoint #{time}",
                          max_national_challenges: 1,
                          max_regional_challenges: 1)
  comp.criteria.create(name: "Project Criterion #{time}",
                       description: "#{time} Description
    to end all descriptions for Project Criterion.", category: PROJECT)
end

2.times do |time|
  comp.criteria.create(name: "Challenge Criterion #{time}", description: "#{time} Description
    to end all descriptions for Challenge Criterion.", category: CHALLENGE)
end

4.times do
  comp.assignments.create(user_id: random_model_id(User), title: MANAGEMENT_TEAM)
end

comp.assignments.create(user_id: random_model_id(User), title: COMPETITION_DIRECTOR)
comp.assignments.create(user_id: random_model_id(User), title: SPONSORSHIP_DIRECTOR)

10.times do
  comp.assignments.create(user_id: random_model_id(User), title: VOLUNTEER)
end

20.times do |time|
  comp.sponsors.create(name: "Vandelay  Industries #{time}",
    description: "Worldwide leader in latex products",
    website: 'http://seinfeld.wikia.com/wiki/Vandelay_Industries',
    created_at: "2018-07-26 23:01:28",
    updated_at: "2018-07-26 23:01:28")
end

10.times do |time|
  comp.sponsorship_types.create(name: "Tier #{time + 1}", order: time + 1)
end

def create_event(event_type, comp, event_name, region, event_start)
  region.events.create(event_type: event_type, competition: comp,
    name: event_name, registration_type: OPEN, capacity: 50,
    email: "#{event_name}@mail.com", twitter: '@qld',
    address: "Eagle Stree, #{region.name} QLD, 4217",
    accessibility: 'Access through the stairs',
    youth_support: 'Always here.', parking: 'None, on street.',
    public_transport: 'Trains near by.', operation_hours: '9-5',
    catering: 'Lots of food, vego available.',
    place_id: 'ChIJ15yzA3lakWsRdtSXdwYk7uQ', video_id: '0Mv48ZM7gu4',
    start_time: event_start,
    end_time: event_start + 2.hours, published: true)
end

def assign_participants(event)
  Assignment.where(title: PARTICIPANT).take(20).each do |participant|
    event.registrations.create(status: ATTENDING, assignment: participant)
  end
end

def assign_event_supports_and_partnership(event)
  EventPartnership.create(event: event, sponsor_id: random_model_id(Sponsor))
  event.assignments.create(user_id: random_model_id(User), title: EVENT_HOST)
  event.assignments.create(user_id: random_model_id(User), title: EVENT_SUPPORT)
  event.assignments.create(user_id: random_model_id(User), title: EVENT_SUPPORT)
end

def fill_out_comp_event(event)

  events = Event.where(event_type: COMPETITION_EVENT).all
  assignment_ids = Registration.where(event: events).pluck(:assignment_id)
  user_ids = Assignment.where(id: assignment_ids).pluck(:user_id)
  competitors = User.where(id: user_ids)

  10.times do |team_time|
    team = event.teams.create

    team.assign_leader(competitors.sample)
    (1 + rand(8)).times do
      team.assignments.create(title: TEAM_MEMBER, user: competitors.sample)
    end

    2.times do
      team.assignments.create(title: INVITEE, user: competitors.sample)
    end

    (1 + rand(20)).times do |time|
      team.projects.create(team_name: "#{event.name} team #{team_time}",
      description: "Best team evaaaaaa! version #{time}",
      project_name: "#{event.name} project #{team_time}",
      data_story: 'We will be taking a big data approach.',
      source_code_url: 'https://github.com/tenderlove/allocation_sampler',
      video_url: 'https://www.youtube.com/embed/kqcrEFkA8g0',
      homepage_url: 'https://www.govhack.org/',
      user: team.assignments.first.user)
    end

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
        challenge_id: random_model_id(Challenge),
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

  region.assignments.create(user_id: random_model_id(User), title: REGION_DIRECTOR)

  3.times do
    region.assignments.create(user_id: random_model_id(User), title: REGION_SUPPORT)
  end

  3.times do
    region.sponsorships.create(sponsor_id: random_model_id(Sponsor),
    sponsorship_type_id: random_model_id(SponsorshipType))
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

  region.challenges.each do |challenge|
    5.times do
      challenge.challenge_data_sets.create(data_set_id: random_model_id(region.data_sets))
    end

    3.times do
      challenge.challenge_sponsorships.create(sponsor_id: random_model_id(Sponsor))
    end

    3.times do
      challenge.assignments.create(title: JUDGE, user_id: random_model_id(User))
    end
  end

  event_name = region.time_zone
  event_name ||= 'Australia'

  EVENT_TYPES.each do |event_type|

    next if event_name == 'Australia' && event_type == COMPETITION_EVENT

    if event_type == COMPETITION_EVENT
      event = create_event(event_type, comp, "Remote #{region.name}",
        region, comp_start)
      assign_participants(event)
      fill_out_comp_event(event)
      assign_event_supports_and_partnership(event)
      event = create_event(event_type, comp, event_name, region, comp_start)
      assign_participants(event)
      fill_out_comp_event(event)
      assign_event_supports_and_partnership(event)
    elsif event_type == CONNECTION_EVENT
      event = create_event(event_type, comp, event_name, region,
        comp_start - 1.months)
      assign_participants(event)
      assign_event_supports_and_partnership(event)
    elsif event_type == AWARD_EVENT
      event = create_event(event_type, comp, event_name, region,
        comp_start + 1.months)
      assign_participants(event)
      assign_event_supports_and_partnership(event)
      if event_name == 'Australia'
        8.times do
          event.flights.create(description: 'Timbuktu',
            direction: FLIGHT_DIRECTIONS.sample)
        end
        3.times do |time|
          bulk_mail = event.bulk_mails.create(user_id: 1,
            name: "Bulk Mail #{time}", status: DRAFT,
            from_email: ENV['SEED_EMAIL'], subject: 'Greetings',
            body: 'Hello { display_name }, How are you?')
          bulk_mail.user_orders.create(request_type: USER_ORDER_QUERIES.sample)
        end
      end
    end
  end
end

comp.teams.all.each do |team|
  Assignment.where(title: PARTICIPANT).take(20).each do |assignment|
    scorecard = Scorecard.create(judgeable: team, assignment: assignment,
      included: (assignment.id % 5 != 0))
    comp.project_criteria.each do |criterion|
      score = Random.rand(11)
      score = nil if score.zero?
      Judgment.create(criterion: criterion, scorecard: scorecard, score: score)
    end
  end
end

Entry.all.each do |entry|
  Assignment.where(title: JUDGE, assignable_id: entry.challenge_id).each do |assignment|
    scorecard = Scorecard.create(judgeable: entry, assignment: assignment,
      included: (assignment.id % 5 != 0))
    comp.challenge_criteria.each do |criterion|
      score = Random.rand(11)
      score = nil if score.zero?
      Judgment.create(criterion: criterion, scorecard: scorecard, score: score)
    end
  end
end

User.all.each do |user|
  event_assignment = user.event_assignment
  6.times do
    Favourite.create(assignment: event_assignment, team_id: random_model_id(Team))
  end
end
