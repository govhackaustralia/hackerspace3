require_relative 'seeder'

class EventSeeder < Seeder
  def self.create(event_type, event_name, region, event_start, comp, sponsors, users, participant_assignments)
    event = region.events.create(
      event_type: event_type,
      name: event_name + ' ' + comp.year.to_s,
      registration_type: OPEN,
      capacity: 50,
      email: "#{event_name}@mail.com",
      twitter: '@qld',
      address: "#{Faker::Address.street_address }, #{region.name}, #{Faker::Address.building_number}",
      accessibility: Faker::Lorem.paragraph,
      youth_support: Faker::Lorem.paragraph,
      parking: Faker::Lorem.paragraph,
      public_transport: Faker::Lorem.paragraph ,
      operation_hours: '9-5',
      catering: Faker::Lorem.paragraph ,
      place_id: 'ChIJ15yzA3lakWsRdtSXdwYk7uQ',
      video_id: '0Mv48ZM7gu4',
      start_time: event_start += [*1..5].sample.days,
      end_time: event_start + 2.hours,
      published: true
    )

    EventPartnership.create(
      event: event,
      sponsor: sponsors.sample
    )

    event.host_assignments.create(
      user: users.sample
    )

    2.times do
      event.support_assignments.create(
        user: users.sample
      )
    end

    20.times do
      event.registrations.attending.create(
        assignment: participant_assignments.sample
      )
    end

    if event_type == COMPETITION_EVENT
      Holder.where(id: event.registrations.attending.pluck(:holder_id)).preload(:user).each do |holder|
        holder.update aws_credits_requested: holder.user.aws_credits_requested
      end
    end

    event
  end

  def self.create_national_awards(event, comp)
    8.times do
      event.flights.create(
        description: Faker::TvShows::GameOfThrones.city + ' ' + comp.year.to_s,
        direction: FLIGHT_DIRECTIONS.sample
      )
    end
    3.times do |time|
      bulk_mail = event.bulk_mails.create(
        user_id: 1,
        name: "Bulk Mail #{time} #{comp.year}",
        status: DRAFT,
        from_email: ENV['SEED_EMAIL'],
        subject: 'Greetings',
        body: 'Hello { display_name }, How are you?'
      )
      bulk_mail.user_orders.create(
        request_type: USER_ORDER_QUERIES.sample
      )
    end
  end
end
