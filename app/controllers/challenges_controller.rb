class ChallengesController < ApplicationController
  def index
    index_variables
    challenge_entry_counts
    filter_challenges
    respond_to do |format|
      format.html
      format.csv { send_data @challenges.to_csv }
    end
  end

  def show
    show_variables
    challenge_show_entry_management
    @region_privileges = user_signed_in? && current_user.region_privileges?
    return if helpers.competition_started_or_region_privileges? @region.time_zone

    redirect_to root_path
  end

  private

  def index_variables
    @competition = Competition.current
    @challenges = @competition.challenges.approved.order(:name).preload(:region)
    root_region = @competition.root_region
    @regions = ([root_region] << root_region.sub_regions.order(:name)).flatten
    @region_privileges = user_signed_in? && current_user.region_privileges?
  end

  def show_variables
    @competition = Competition.current
    @challenge = Challenge.find_by(identifier: params[:identifier])
    @challenge = Challenge.find(params[:identifier]) if @challenge.nil?
    @region = @challenge.region
    @data_sets = @challenge.data_sets
    @challenge_sponsorships = @challenge.challenge_sponsorships
  end

  def challenge_show_entry_management
    @user_eligible_teams = @challenge.eligible_teams & current_user.teams if user_signed_in?
    if @competition.either_judging_window_open?(LAST_TIME_ZONE)
      judging_view
    else
      checkpoint_entry_view
    end
  end

  def judging_view
    @teams = @challenge.teams.where(published: true)
    @projects = @challenge.published_projects_by_name.preload(:event)
    return unless user_signed_in?

    user_judging
  end

  def user_judging
    if (@judgeable_assignment = current_user.judgeable_assignment).present?
      @peoples_assignment = current_user.peoples_assignment
      @project_judging = @judgeable_assignment.judgeable_scores(@teams)
      @project_judging_total = @competition.score_total PROJECT
    end
    return unless (@judge = current_user.judge_assignment(@challenge)).present?

    @challenge_judging = @judge.judgeable_scores(@teams)
    @challenge_judging_total = @competition.score_total CHALLENGE
  end

  def checkpoint_entry_view
    passed_checkpoint_ids = if @region.national?
                              @competition.passed_checkpoint_ids(LAST_TIME_ZONE)
                            else
                              @competition.passed_checkpoint_ids(@region.time_zone)
                            end
    @passed_public_checkpoints = @competition.checkpoints.where(id: passed_checkpoint_ids).order(:end_time)
    team_ids = @challenge.entries.where(checkpoint_id: passed_checkpoint_ids).pluck(:team_id)
    @teams = Team.where(id: team_ids, published: true)
  end

  def challenge_entry_counts
    all_entries = all_region_entries
    unpublished_entries = Entry.where(team: Team.where(published: false)).to_a
    published_entries = all_entries - unpublished_entries
    @challenge_id_to_entry_count = {}
    @challenges.each { |challenge| @challenge_id_to_entry_count[challenge.id] = 0 }
    published_entries.each { |entry| @challenge_id_to_entry_count[entry.challenge_id] += 1 }
  end

  def all_region_entries
    all_entries = []
    @competition.regions.all.each do |region|
      passed_checkpoint_ids = if region.national?
                                @competition.passed_checkpoint_ids(LAST_TIME_ZONE)
                              else
                                @competition.passed_checkpoint_ids(region.time_zone)
                              end
      all_entries += region.entries.where(checkpoint_id: passed_checkpoint_ids).to_a
    end
    all_entries
  end

  def filter_challenges
    @region_challenges = {}
    @regions.each { |r| @region_challenges[r.id] = [] }
    if params[:term].present?
      @challenges.each { |challenge| search_challenge_string(challenge, params[:term]) }
    else
      @challenges.each { |challenge| @region_challenges[challenge.region_id] << challenge }
    end
  end

  def search_challenge_string(challenge, term)
    challenge_string = "#{challenge.name} #{challenge.short_desc} #{challenge.region.name}".downcase
    @region_challenges[challenge.region_id] << challenge if challenge_string.include? term.downcase
  end
end
