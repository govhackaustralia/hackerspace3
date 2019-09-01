class EntriesController < ApplicationController
  def index
    passed_checkpoint_ids = @competition.passed_checkpoint_ids LAST_TIME_ZONE
    @region_counts = helpers.challenges_region_counts @competition, passed_checkpoint_ids
    @sub_regions = @competition.regions.lows.order :name
    @region_names = @sub_regions.pluck :name
    @root_region = @competition.international_region
    @challenge_names = @root_region.challenges.order(:name).pluck :name
  end
end
