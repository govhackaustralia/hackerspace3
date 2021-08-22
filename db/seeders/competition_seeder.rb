require_relative 'seeder'
require_relative 'user_seeder'
require_relative 'region_seeder'

class CompetitionSeeder < Seeder
  def self.create offset = 0
    year = Time.current.year + offset
    competition_start = Seeder.competition_start + offset.years
    competition_end = competition_start + 3.days
    team_form_start = competition_start - 1.weeks
    team_form_end = competition_end
    peoples_start = competition_start + 1.weeks
    peoples_end = peoples_start + 1.weeks
    judging_start = competition_start + 1.weeks
    judging_end = judging_start + 1.weeks
    users = User.all

    competition = Competition.create!(
      team_form_start: team_form_start,
      team_form_end: team_form_end,
      start_time: competition_start,
      end_time: competition_end,
      peoples_choice_start: peoples_start,
      peoples_choice_end: peoples_end,
      challenge_judging_start: judging_start,
      challenge_judging_end: judging_end,
      year: year,
      current: Time.current.year == year,
      hunt_published: Time.current.year == year
    )

    UserSeeder.create_admin competition

    competition.checkpoints.create(
      end_time: competition_end,
      name: "Checkpoint #{competition.year}",
      max_national_challenges: 5,
      max_regional_challenges: 5
    )

    5.times do |time|
      competition.criteria.create(
        name: "Project Criterion #{time} #{competition.year}",
        description: Faker::Lorem.paragraph,
        category: PROJECT
      )
      competition.hunt_questions.create(
        question: "What is the answer to question #{time}? #{Faker::Lorem.paragraph}",
        answer: "Answer #{time}"
      )
    end

    2.times do |time|
      competition.criteria.create(
        name: "Challenge Criterion #{time} #{competition.year}",
        description: Faker::Lorem.paragraph,
        category: CHALLENGE
      )
    end

    return unless users.any?

    4.times do
      user = users.sample
      competition.assignments.create(
        user: user,
        title: MANAGEMENT_TEAM,
        holder: user.holder_for(competition)
      )
    end

    user = users.sample
    competition.assignments.create(
      user: user,
      title: COMPETITION_DIRECTOR,
      holder: user.holder_for(competition)
    )

    user = users.sample
    competition.assignments.create(
      user: user,
      title: SPONSORSHIP_DIRECTOR,
      holder: user.holder_for(competition)
    )


    10.times do
      user = users.sample
      competition.assignments.volunteers.create(
        user: user,
        holder: user.holder_for(competition)
      )
    end

    [*10..20].sample.times do |time|
      sponsor = competition.sponsors.create(
        name: Faker::Company.name + ' ' + competition.year.to_s,
        description: Faker::Lorem.paragraph,
        url: 'http://seinfeld.wikia.com/wiki/Vandelay_Industries'
      )
      [*0..2].sample.times do |time|
        competition.visits.create(
          user: users.sample,
          visitable: sponsor
        )
      end
    end

    5.times do |time|
      competition.sponsorship_types.create(
        name: "Tier #{time + 1} #{competition.year}",
        position: time + 1
      )
    end

    5.times do
      badge = competition.badges.create(name: "#{Faker::Color.unique.color_name} Badge")
      [*10..20].sample.times do |time|
        user = users.sample
        badge.assignments.create(
          title: ASSIGNEE,
          user: user,
          holder: user.holder_for(competition)
        )
      end
    end

    3.times do |time|
      resource = competition.resources.information.create!(
        position: time,
        name: "Information #{time}",
        url: "https://www.information#{time}.com",
        short_url: "information.#{time}",
        show_on_front_page: random_boolean
      )
      [*0..2].sample.times do |time|
        competition.visits.create(
          user: users.sample,
          visitable: resource
        )
      end
    end

    5.times do |time|
      resource = competition.resources.tech.create!(
        position: time,
        name: "Tech #{time}",
        url: "https://www.tech#{time}.com",
        short_url: "tech.#{time}",
      )
      [*0..2].sample.times do |time|
        competition.visits.create(
          user: users.sample,
          visitable: resource
        )
      end
    end

    20.times do |time|
      resource = competition.resources.data_portal.create!(
        position: time,
        name: "Data Portal #{time}",
        url: "https://www.data_portal#{time}.com",
        short_url: "data_portal.#{time}"
      )
      [*0..2].sample.times do |time|
        competition.visits.create(
          user: users.sample,
          visitable: resource
        )
      end
    end

    competition.update hunt_badge: competition.badges.sample

    Faker::Color.unique.clear

    users.each { |user| user.event_assignment(competition) }

    RegionSeeder.create competition
    UserSeeder.create_favourites competition
  end
end
