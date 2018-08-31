class ChallengesController < ApplicationController
  def index
    @competition = Competition.current
    @challenges = @competition.challenges.where(approved: true)
    @id_regions = Region.id_regions(@challenges.pluck(:region_id))
    challenge_entry_counts
    respond_to do |format|
      format.html
      format.csv { send_data @challenges.to_csv }
    end
  end

  def show
    @challenge = Challenge.find(params[:id])
    @region = @challenge.region
    return if @challenge.competition.started?
    redirect_to root_path
  end

  private

  def challenge_entry_counts
    entries = Entry.where(challenge_id: @challenges.pluck(:id))
    @challenge_id_to_entry_count = {}
    @challenges.each { |challenge| @challenge_id_to_entry_count[challenge.id] = 0 }
    entries.each { |entry| @challenge_id_to_entry_count[entry.challenge_id] += 1 }
  end
end
