class EntriesController < ApplicationController
  def index
    @challenge = Challenge.find(params[:challenge_id])
    @entries = @challenge.entries
    @checkpoints = @challenge.competition.checkpoints.order(:end_time)
  end
end
