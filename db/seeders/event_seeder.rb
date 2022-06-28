require_relative 'seeder'

class EventSeeder < Seeder
  def self.create(event_type, event_name, region, event_start, competition, sponsors, users, participant_assignments)
    event = region.events.create(
      event_type: event_type,
      name: event_name + ' ' + competition.year.to_s,
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

    return unless sponsors.any?

    EventPartnership.create(
      event: event,
      sponsor: sponsors.sample
    )

    return unless users.any?

    user = users.sample
    event.host_assignments.create(
      user: user,
      holder: user.holder_for(competition)
    )

    2.times do
      user = users.sample
      event.support_assignments.create(
        user: user,
        holder: user.holder_for(competition)
      )
    end

    return unless participant_assignments.any?

    [*0..20].sample.times do
      assignment = participant_assignments.sample
      event.registrations.attending.create(
        assignment: assignment,
        holder_id: assignment.holder_id
      )
    end

    if event_type == COMPETITION_EVENT
      Holder.where(id: event.registrations.attending.pluck(:holder_id)).each do |holder|
        holder.update aws_credits_requested: random_boolean
      end
    end

    event
  end
end
