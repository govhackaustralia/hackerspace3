class ChallengesController < ApplicationController

  def index
    @competition = Competition.current
  end

  def show
    @challenge = Challenge.find(params[:id])
    @region = @challenge.region
  end
end
