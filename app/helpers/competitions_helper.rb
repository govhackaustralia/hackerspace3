module CompetitionsHelper
  def competition_started_or_region_privileges?(time_zone = nil)
    @competition.started?(time_zone) || @region_privileges
  end

  def in_competition_window_or_region_privileges?(time_zone = nil)
    @competition.in_window?(time_zone) || @region_privileges
  end
end
