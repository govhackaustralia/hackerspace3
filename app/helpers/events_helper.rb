module EventsHelper
  def participant_able_to_enter?
    return true unless @event.competition_event?

    ! @competition.already_participating_in_a_competition_event?(@event_assignment)
  end
end
