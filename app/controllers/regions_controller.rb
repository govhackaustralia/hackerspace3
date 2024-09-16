# frozen_string_literal: true

class RegionsController < ApplicationController
  before_action :check_show

  def show
    @challenges = @region.approved_challenges
      .preload(:sponsors_with_logos, :published_entries)
    national_challenges
    nation_wides
    international_challenges
    regions
    national_regions
    eligible_locations
  end

  private

  def national_challenges
    @national_challenges = if national.present?
      national.approved_challenges
        .preload(:sponsors_with_logos, :published_entries)
    else
      []
    end
  end

  def nation_wides
    @nation_wides = if national.present?
      national.sub_region_challenges.nation_wides.approved
        .order(:name)
        .preload(:sponsors_with_logos, :published_entries)
    else
      []
    end
  end

  def international_challenges
    @international_challenges = international.approved_challenges
      .preload(:sponsors_with_logos, :published_entries)
  end

  def regions
    @regions = if @region.national?
      @region.sub_regions
    else
      []
    end
  end

  def national_regions
    @national_regions = if @region.international?
      @region.sub_regions
    else
      []
    end
  end

  def national
    @national ||= if @region.regional?
      @region.parent
    elsif @region.national?
      @region
    end
  end

  def international
    @international ||= if @region.international?
      @region
    else
      @national.parent
    end
  end

  def check_show
    @region = @competition.regions.find_by_identifier params[:id]
    @checker = ShowChallengesChecker.new @competition
    return if (@region.is_show == 1) || (@checker.show? @region)

    redirect_to challenges_path, alert: 'Region not visible at this time'
  end

  def eligible_locations
    # @eligible_locations = [
    #  {label: 'NSW', path: 'new_south_wales_2024'},
    #  {label: 'QLD', path: 'queensland_2024'},
    #  {label: 'VIC', path: 'victoria_2024'},
    #  {label: 'SA', path: 'south_australia_2024'},
    #  {label: 'WA', path: 'western_australia_2024'},
    #  {label: 'TAS', path: 'tasmania_2024'},
    #  {label: 'Australia', path: 'australia2024'},
    #  {label: 'New Zealand', path: 'new_zealand2024'},
    #  {label: 'International', path: 'international_2024'},
    # ]

    regions = @competition.regions.order(:category, :name)

    @eligible_locations = regions.map do |region|
      {
        label: region.name,
        path: region.identifier,
      }
    end
  end
end
