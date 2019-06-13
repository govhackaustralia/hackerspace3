class EntriesController < ApplicationController
  def index
    @competition = Competition.current
    retrieve_regions
  end

  private

  def retrieve_regions
    passed_checkpoint_ids = @competition.passed_checkpoint_ids LAST_TIME_ZONE
    @region_counts = helpers.challenges_region_counts @competition, passed_checkpoint_ids
    @sub_regions = @competition.regions.subs.order :name
    @region_names = @sub_regions.pluck :name
    @challenge_names = @competition.root_region.challenges.order(:name).pluck :name
  end
end
