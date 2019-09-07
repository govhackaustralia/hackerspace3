class ChallengesController < ApplicationController
  before_action :check_competition_start!, only: :show
  before_action :check_competition_index_landing_page!, only: :index
  before_action :check_competition_landing_page_index!, only: :landing_page

  def index
    @challenges = @competition.challenges.approved.order(:name).preload(
      challenge_sponsorships: :sponsor
    )
    @regions = @competition.regions.order(:category).order :name
    challenge_entry_counts
    filter_challenges
    respond_to do |format|
      format.html
      format.csv { send_data @challenges.to_csv @competition }
    end
  end

  def landing_page
    return unless (@started = @competition.started?(FIRST_TIME_ZONE))

    @regions = @competition.regions
  end

  def show
    @data_sets = @challenge.data_sets
    @challenge_sponsorships = @challenge.challenge_sponsorships
    @challenges = @competition.challenges.approved
    challenge_show_entry_management
    challenge_entry_counts
  end

  private

  def check_competition_index_landing_page!
    return unless landing_page?

    redirect_to landing_page_challenges_path
  end

  def check_competition_landing_page_index!
    return if landing_page?

    redirect_to challenges_path
  end

  def landing_page?
    return false if @competition.started? LAST_TIME_ZONE

    return false if user_signed_in? &&
                    (@event = current_user.participating_competition_event(@competition)).present? &&
                    @competition.started?(@event.region.time_zone)

    true
  end

  def check_competition_start!
    @challenge = Challenge.find_by identifier: params[:identifier]
    @challenge = Challenge.find(params[:identifier]) if @challenge.nil?
    @region = @challenge.region
    return if @competition.started?(@region.time_zone) || @region.international?

    flash[:alert] = 'Challenges will become visible at the start of the competition'
    redirect_to root_path
  end

  def challenge_show_entry_management
    @user_eligible_teams = @challenge.eligible_teams & current_user.joined_teams if user_signed_in?
    if @competition.either_judging_window_open?(LAST_TIME_ZONE)
      judging_view
    else
      checkpoint_entry_view
    end
  end

  def judging_view
    @teams = @challenge.teams.published
    @projects = @challenge.published_projects_by_name.preload :event
    return unless user_signed_in?

    user_judging
  end

  def user_judging
    if (@judgeable_assignment = current_user.judgeable_assignment @competition).present?
      @peoples_assignment = current_user.peoples_assignment @competition
      @project_judging = @judgeable_assignment.judgeable_scores @teams
      @project_judging_total = @competition.score_total PROJECT
    end
    return unless (@judge = current_user.judge_assignment(@challenge)).present?

    @challenge_judging = @judge.judgeable_scores @teams
    @challenge_judging_total = @competition.score_total CHALLENGE
  end

  def checkpoint_entry_view
    @passed_public_checkpoints = @competition.checkpoints.where(id: passed_checkpoint_ids(@region)).order(:end_time)
    team_ids = @challenge.entries.where(checkpoint_id: passed_checkpoint_ids(@region)).pluck(:team_id)
    @teams = Team.published.where(id: team_ids)
  end

  def challenge_entry_counts
    all_entries = all_region_entries
    unpublished_entries = Entry.where(team: @competition.teams.unpublished).to_a
    published_entries = all_entries - unpublished_entries
    @challenge_id_to_entry_count = {}
    @challenges.each { |challenge| @challenge_id_to_entry_count[challenge.id] = 0 }
    published_entries.each do |entry|
      challenge_array = @challenge_id_to_entry_count[entry.challenge_id]
      next if challenge_array.nil?
      challenge_array += 1
    end
  end

  def all_region_entries
    all_entries = []
    @competition.regions.each do |region|
      all_entries += region.entries.where(
        checkpoint_id: passed_checkpoint_ids(region)
      ).to_a
    end
    all_entries
  end

  def passed_checkpoint_ids(region)
    if region.international?
      @competition.passed_checkpoint_ids(LAST_TIME_ZONE)
    else
      @competition.passed_checkpoint_ids(region.time_zone)
    end
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
