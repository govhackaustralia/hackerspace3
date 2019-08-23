module CompetitionsHelper
  # Returns true if the competition has started or if a user has region
  # privileges
  def competition_started_or_region_privileges?(time_zone = nil)
    @competition.started?(time_zone) || @region_privileges
  end

  # Returns true if a competition window is open or a user has region
  # privileges
  def in_competition_window_or_region_privileges?(time_zone = nil)
    @competition.in_comp_window?(time_zone) || @region_privileges
  end
end
