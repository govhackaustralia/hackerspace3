# frozen_string_literal: true

module EventsHelper
  def participant_able_to_enter?
    return true unless @event.competition_event?

    ! @competition.already_participating_in_a_competition_event?(@event_assignment)
  end

  def event_registration_closed?(event, region, competition)
    end_time = event.end_time || competition.end_time
    end_time.in_time_zone(region.time_zone.presence || LAST_COMPETITION_TIME_ZONE)
      .to_formatted_s(:number) < region.time
  end
end
