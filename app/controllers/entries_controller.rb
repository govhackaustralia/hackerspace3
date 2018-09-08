class EntriesController < ApplicationController
  def index
    @competition = Competition.current
    passed_checkpoint_ids = @competition.passed_checkpoint_ids(LAST_TIME_ZONE)
    @region_counts = Region.national_challenges_region_counts(passed_checkpoint_ids)
    @region_names = Region.where.not(parent_id: nil).order(:name).pluck(:name)
    @challenge_names = Region.root.challenges.order(:name).pluck(:name)
    @sub_regions = Region.where.not(parent_id: nil).order(:name)
  end
end
