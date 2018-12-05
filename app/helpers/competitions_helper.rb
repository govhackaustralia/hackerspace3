module CompetitionsHelper
  def competition_started?(time_zone = nil)
    @competition.start_time.to_formatted_s(:number) < region_time(time_zone)
  end

  def competition_not_finished?(time_zone = nil)
    region_time(time_zone) < @competition.end_time.to_formatted_s(:number)
  end

  def in_competition_window?(time_zone = nil)
    competition_started?(time_zone) && competition_not_finished?(time_zone)
  end

  def in_challenge_judging_window?(time_zone = nil)
    in_window?(time_zone, @competition.challenge_judging_start, @competition.challenge_judging_end)
  end

  def in_peoples_judging_window?(time_zone = nil)
    in_window?(time_zone, @competition.peoples_choice_start, @competition.peoples_choice_end)
  end

  def is_either_judging_window_open?(time_zone = nil)
    in_challenge_judging_window?(time_zone) || in_peoples_judging_window?(time_zone)
  end

  private

  def region_time(time_zone)
    if time_zone.present?
      Time.now.in_time_zone(time_zone).to_formatted_s(:number)
    else
      Time.now.in_time_zone(COMP_TIME_ZONE).to_formatted_s(:number)
    end
  end

  def in_window?(time_zone, start_time, end_time)
    time = region_time(time_zone)
    started = start_time.to_formatted_s(:number) < time
    not_finished = time < end_time.to_formatted_s(:number)
    started && not_finished
  end
end
