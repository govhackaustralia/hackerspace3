require_relative 'seeder'
require_relative 'user_seeder'
require_relative 'region_seeder'

class CompetitionSeeder < Seeder
  def self.create offset = 0
    year = Time.current.year + offset
    comp_start = Seeder.comp_start + offset.years
    comp_end = comp_start + 3.days
    team_form_start = comp_start - 1.weeks
    team_form_end = comp_end
    peoples_start = comp_start + 1.weeks
    peoples_end = peoples_start + 1.weeks
    judging_start = comp_start + 1.weeks
    judging_end = judging_start + 1.weeks
    users = User.all

    comp = Competition.create!(
      team_form_start: team_form_start,
      team_form_end: team_form_end,
      start_time: comp_start,
      end_time: comp_end,
      peoples_choice_start: peoples_start,
      peoples_choice_end: peoples_end,
      challenge_judging_start: judging_start,
      challenge_judging_end: judging_end,
      year: year,
      current: Time.current.year == year,
      hunt_published: Time.current.year == year
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
      comp.hunt_questions.create(
        question: "What is the answer to question #{time}? #{Faker::Lorem.paragraph}",
        answer: "Answer #{time}"
      )
    end

    2.times do |time|
      comp.criteria.create(
        name: "Challenge Criterion #{time} #{comp.year}",
        description: Faker::Lorem.paragraph,
        category: CHALLENGE
      )
    end

    return unless users.any?

    4.times do
      user = users.sample
      comp.assignments.create(
        user: user,
        title: MANAGEMENT_TEAM,
        holder: user.holder_for(comp)
      )
    end

    user = users.sample
    comp.assignments.create(
      user: user,
      title: COMPETITION_DIRECTOR,
      holder: user.holder_for(comp)
    )

    user = users.sample
    comp.assignments.create(
      user: user,
      title: SPONSORSHIP_DIRECTOR,
      holder: user.holder_for(comp)
    )


    10.times do
      user = users.sample
      comp.assignments.volunteers.create(
        user: user,
        holder: user.holder_for(comp)
      )
    end

    [*10..20].sample.times do |time|
      comp.sponsors.create(
        name: Faker::Company.name + ' ' + comp.year.to_s,
        description: Faker::Lorem.paragraph,
        website: 'http://seinfeld.wikia.com/wiki/Vandelay_Industries'
      )
    end

    5.times do |time|
      comp.sponsorship_types.create(
        name: "Tier #{time + 1} #{comp.year}",
        position: time + 1
      )
    end

    5.times do
      badge = comp.badges.create(name: "#{Faker::Color.unique.color_name} Badge")
      [*10..20].sample.times do |time|
        user = users.sample
        badge.assignments.create(
          title: ASSIGNEE,
          user: user,
          holder: user.holder_for(comp)
        )
      end
    end
    comp.update hunt_badge: comp.badges.sample

    Faker::Color.unique.clear

    users.each { |user| user.event_assignment(comp) }

    RegionSeeder.create comp
    UserSeeder.create_favourites comp
  end
end
