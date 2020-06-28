class ChallengesController < ApplicationController
  before_action :check_competition_start!, only: %i[show entries]
  before_action :check_competition_index_landing_page!,
                :preferred_index_view, only: %i[index table]
  before_action :check_competition_landing_page_index!, only: :landing_page

  def index
    @regions = @competition.regions
      .order(:category, :name)
      .preload(approved_challenges: :sponsors_with_logos)
    @entry_counter = PublishedEntryCounter.new @competition
    @checker = ShowChallengesChecker.new @competition
  end

  def table
    @challenges = @competition.challenges.approved
      .order(:name)
      .preload(:region, :sponsors, :published_entries)
    @entry_counter = PublishedEntryCounter.new @competition
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
    @sponsors = @challenge.sponsors.with_attached_logo

    @user_eligible_teams = @challenge.eligible_teams & current_user.joined_teams if user_signed_in?
  end

  def entries
    @challenges = @competition.challenges.approved
    if @competition.either_judging_window_open?(LAST_TIME_ZONE)
      judging_view
    else
      checkpoint_entry_view
    end
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

  def judging_view
    @teams = @challenge.teams.published
    @projects = @challenge.published_projects_by_name.preload :event
    return unless user_signed_in?

    user_judging
  end

  def user_judging
    peoples_project_judging
    return unless (@judge = current_user.judge_assignment(@challenge)).present?

    @challenge_judging = JudgeableScores.new(@judge, @teams).compile
    @challenge_judging_total = @competition.score_total CHALLENGE
  end

  def peoples_project_judging
    return unless (@judgeable_assignment = current_user.judgeable_assignment(@competition)).present?

    @peoples_assignment = current_user.peoples_assignment @competition
    @project_judging = JudgeableScores.new(@judgeable_assignment, @teams).compile
    @project_judging_total = @competition.score_total PROJECT
  end

  def checkpoint_entry_view
    @time_zone = @region.time_zone || LAST_TIME_ZONE
    passed_public_checkpoints = @competition.checkpoints
      .where(id: passed_checkpoint_ids(@region))
    @entries = @challenge.published_entries
      .where(checkpoint: passed_public_checkpoints)
      .preload(:checkpoint, project: :event)
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

  def preferred_index_view
    cookies[:challenge_index_view] = params[:action]
  end

  def search_challenge_string(challenge, term)
    challenge_string = "#{challenge.name} #{challenge.short_desc} #{challenge.region.name}".downcase
    @region_challenges[challenge.region_id] << challenge if challenge_string.include? term.downcase
  end
end
