module CompetitionsHelper
  # Returns true if the competition has started or if a user has region
  # privileges
  def competition_started_or_region_privileges?(time_zone = nil)
    @competition.started?(time_zone) || @region_privileges
  end

  # Return true if the cometition is in the team form stage or has started or
  # if a user as region privileges
  def in_form_or_comp_started_or_region_privileges?(time_zone = nil)
    @competition.in_form_or_comp_started?(time_zone) || @region_privileges
  end

  # Returns true if a competition window is open or a user has region
  # privileges
  def in_form_or_comp_window_or_region_privileges?(time_zone = nil)
    @competition.in_form_or_comp_window?(time_zone) || @region_privileges
  end
end
