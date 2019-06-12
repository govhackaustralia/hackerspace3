require_relative 'team_seeder'
require_relative 'event_seeder'
require_relative 'seeder'

class RegionSeeder < Seeder
  def self.create(comp)
    connection_start = comp_start - 1.months
    award_start = comp_start + 3.weeks
    award_release = award_start
    users = User.all
    sponsors = comp.sponsors
    sponsorship_types = comp.sponsorship_types
    participant_assignments = comp.competition_assignments.participants
    challenges = comp.challenges

    root_region = comp.regions.create(
      name: 'Australia' + ' ' + comp.year.to_s
    )

    [
      {name: 'New South Wales', time_zone: 'Sydney'},
      {name: 'Victoria', time_zone: 'Melbourne'},
      {name: 'South Australia', time_zone: 'Adelaide'},
      {name: 'Western Australia', time_zone: 'Perth'},
      {name: 'Tasmania', time_zone: 'Hobart'},
      {name: 'Tasmania', time_zone: 'Hobart'},
      {name: 'ACT', time_zone: 'Canberra'},
      {name: 'Queensland', time_zone: 'Brisbane'}
    ].each do |name_and_time_zone|
      comp.regions.create name_and_time_zone.merge(
        name: name_and_time_zone[:name] + ' ' + comp.year.to_s,
        parent: root_region,
        award_release: award_release
      )
    end

    comp.regions.all.each do |region|

      region.assignments.create(
        user: users.sample,
        title: REGION_DIRECTOR
      )

      3.times do
        region.assignments.create(
          user: users.sample,
          title: REGION_SUPPORT
        )
      end

      3.times do
        region.sponsorships.create(
          sponsor: sponsors.sample,
          sponsorship_type: sponsorship_types.sample
        )
      end

      5.times do |time|
        region.challenges.create(
          name: "#{region.name} #{Faker::Games::Pokemon.unique.name} Challenge #{comp.year}",
          short_desc: Faker::Lorem.sentence, approved: true,
          long_desc: Faker::Lorem.paragraph,
          eligibility: 'You must be this tall to go on this ride.',
          video_url: 'https://www.youtube.com/embed/kqcrEFkA8g0'
        )
      end

      10.times do |time|
        region.data_sets.create(
          name: "#{region.name} Data Set #{time} #{comp.year}",
          url: "https://data.gov.au/dataset/#{Faker::Movies::HarryPotter.character}",
          description: Faker::Lorem.paragraph
        )
      end

      3.times do |time|
        region.bulk_mails.create(
          user_id: 1,
          name: "Bulk Mail #{time} #{comp.year}",
          status: DRAFT,
          from_email: ENV['SEED_EMAIL'],
          subject: 'Greetings',
          body: 'Hello { display_name }, How is { team_name } going with { project_name } ?'
        )
      end

      data_sets = region.data_sets
      region.challenges.each do |challenge|
        5.times do
          challenge.challenge_data_sets.create(
            data_set: data_sets.sample
          )
        end

        3.times do
          challenge.challenge_sponsorships.create(
            sponsor: sponsors.sample
          )
        end

        3.times do
          challenge.assignments.judges.create(
            user: users.sample,
          )
        end
      end

      event_name = if region.time_zone.nil?
                    root_region.name
                   else
                    Faker::TvShows::GameOfThrones.city
                   end

      EVENT_TYPES.each do |event_type|

        next if event_name == root_region.name && event_type == COMPETITION_EVENT

        comp_start = comp.start_time
        if event_type == COMPETITION_EVENT
          event = EventSeeder.create(event_type, "Remote #{region.name}", region, comp_start, comp, sponsors, users, participant_assignments)
          TeamSeeder.create(event, comp, participant_assignments, challenges)
          event = EventSeeder.create(event_type, event_name, region, comp_start, comp, sponsors, users, participant_assignments)
          TeamSeeder.create(event, comp, participant_assignments, challenges)
        elsif event_type == CONNECTION_EVENT
          event = EventSeeder.create(event_type, event_name, region, connection_start, comp, sponsors, users, participant_assignments)
        elsif event_type == AWARD_EVENT
          event = EventSeeder.create(event_type, event_name, region, award_start, comp, sponsors, users, participant_assignments)
          if event_name == root_region.name
            EventSeeder.create_national_awards(event, comp)
          end
        end
      end
    end
  end
end
