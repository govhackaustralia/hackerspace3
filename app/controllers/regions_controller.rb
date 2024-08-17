# frozen_string_literal: true

class RegionsController < ApplicationController
  before_action :check_show

  def show
    @challenges = @region.approved_challenges
      .preload(:sponsors_with_logos, :published_entries)
    @eligible_locations = [
      ['NSW', 'new_south_wales_2024'], 
      ['QLD', 'queensland_2024'],
      ['VIC', 'victoria_2024'],
      ['SA', 'south_australia_2024'],
      ['WA', 'western_australia_2024'],
      ['TAS', 'tasmania_2024'],
      ['Australia', 'australia2024'],
      ['New Zealand', 'new_zealand2024'],
      ['International', 'international_2024'],
    ]
    national_challenges
    nation_wides
    international_challenges
    regions
    national_regions
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
    return if @checker.show? @region

    redirect_to challenges_path, alert: 'Region not visible at this time'
  end
end
