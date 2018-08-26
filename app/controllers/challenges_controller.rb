class ChallengesController < ApplicationController
  def index
    @competition = Competition.current
    @challenges = @competition.challenges.where(approved: true)
    respond_to do |format|
      format.html
      format.csv { send_data @challenges.to_csv }
    end
  end

  def show
    @challenge = Challenge.find(params[:id])
    @region = @challenge.region
  end
end
