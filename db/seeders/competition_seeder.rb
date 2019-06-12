require_relative 'seeder'
require_relative 'user_seeder'
require_relative 'region_seeder'

class CompetitionSeeder < Seeder
  def self.create offset = 0
    year = Time.current.year + offset
    comp_start = Seeder.comp_start + offset.years
    comp_end = comp_start + 3.days
    peoples_start = comp_start + 1.weeks
    peoples_end = peoples_start + 1.weeks
    judging_start = comp_start + 1.weeks
    judging_end = judging_start + 1.weeks
    users = User.all

    comp = Competition.create!(
      start_time: comp_start,
      end_time: comp_end,
      peoples_choice_start: peoples_start,
      peoples_choice_end: peoples_end,
      challenge_judging_start: judging_start,
      challenge_judging_end: judging_end,
      year: year,
      current: Time.current.year == year
    )

    UserSeeder.create_admin comp

    5.times do |time|
      comp.checkpoints.create(
        end_time: comp.start_time + (time * 6).days,
        name: "Checkpoint #{time} #{comp.year}",
        max_national_challenges: 1,
        max_regional_challenges: 1
      )
      comp.criteria.create(
        name: "Project Criterion #{time} #{comp.year}",
        description: Faker::Lorem.paragraph,
        category: PROJECT
      )
    end

    2.times do |time|
      comp.criteria.create(
        name: "Challenge Criterion #{time} #{comp.year}",
        description: Faker::Lorem.paragraph,
        category: CHALLENGE
      )
    end

    4.times do
      comp.assignments.create(
        user: users.sample,
        title: MANAGEMENT_TEAM
      )
    end

    comp.assignments.create(
      user: users.sample,
      title: COMPETITION_DIRECTOR
    )

    comp.assignments.create(
      user: users.sample,
      title: SPONSORSHIP_DIRECTOR
    )

    10.times do
      comp.assignments.volunteers.create(
        user: users.sample
      )
    end

    20.times do |time|
      comp.sponsors.create(
        name: Faker::Company.name + ' ' + comp.year.to_s,
        description: Faker::Lorem.paragraph,
        website: 'http://seinfeld.wikia.com/wiki/Vandelay_Industries'
      )
    end

    10.times do |time|
      comp.sponsorship_types.create(
        name: "Tier #{time + 1} #{comp.year}",
        order: time + 1
      )
    end

    users.each { |user| user.event_assignment(comp) }

    RegionSeeder.create comp
    UserSeeder.create_favourites comp
  end
end
