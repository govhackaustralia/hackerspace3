class ChallengesController < ApplicationController
  def index
    @competition = Competition.current
    @challenges = @competition.challenges.where(approved: true).order(:name)
    @regions = ([Region.root] << Region.where.not(parent_id: nil).order(:name)).flatten
    challenge_entry_counts
    filter_challenges
    respond_to do |format|
      format.html
      format.csv { send_data @challenges.to_csv }
    end
  end

  def show
    @competition = Competition.current
    @challenge = Challenge.find(params[:id])
    @region = @challenge.region
    @data_sets = @challenge.data_sets
    @challenge_sponsorships = @challenge.challenge_sponsorships
    challenge_show_entry_management
    return if @competition.started?(@region.time_zone) || (user_signed_in? && current_user.region_privileges?)
    redirect_to root_path
  end

  private

  def challenge_show_entry_management
    @user_eligible_teams = @challenge.eligible_teams & current_user.teams if user_signed_in?
    passed_checkpoint_ids = if @region.national?
                              @competition.passed_checkpoint_ids(LAST_TIME_ZONE)
                            else
                              @competition.passed_checkpoint_ids(@region.time_zone)
                            end
    @passed_public_checkpoints = @competition.checkpoints.all.where(id: passed_checkpoint_ids).order(:end_time)
    @entries = @challenge.entries.where(checkpoint_id: passed_checkpoint_ids)
    @id_team_projects = Team.id_teams_projects(@entries.pluck(:team_id))
  end

  def challenge_entry_counts
    entries = []
    Region.all.each do |region|
      passed_checkpoint_ids=  if region.national?
                                @competition.passed_checkpoint_ids(LAST_TIME_ZONE)
                              else
                                @competition.passed_checkpoint_ids(region.time_zone)
                              end
      entries += region.entries.where(checkpoint_id: passed_checkpoint_ids).to_a
    end
    @challenge_id_to_entry_count = {}
    @challenges.each { |challenge| @challenge_id_to_entry_count[challenge.id] = 0 }
    entries.each { |entry| @challenge_id_to_entry_count[entry.challenge_id] += 1 }
  end

  def filter_challenges
    @region_challenges = {}
    @regions.each { |r| @region_challenges[r.id] = [] }
    if params[:term].present?
      @id_regions = Region.id_regions(@regions)
      @challenges.each { |challenge| search_challenge_string(challenge, params[:term]) }
    else
      @challenges.each { |challenge| @region_challenges[challenge.region_id] << challenge }
    end
  end

  def search_challenge_string(challenge, term)
    challenge_string = "#{challenge.name} #{challenge.short_desc} #{@id_regions[challenge.region_id].name}".downcase
    @region_challenges[challenge.region_id] << challenge if challenge_string.include? term.downcase
  end
end
