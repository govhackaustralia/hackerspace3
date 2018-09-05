class EntriesController < ApplicationController
  def index
    @competition = Competition.current
    @region_counts = Region.national_challenges_region_counts
    @region_names = Region.where.not(parent_id: nil).order(:name).pluck(:name)
    @challenge_names = Region.root.challenges.order(:name).pluck(:name)
  end
end
