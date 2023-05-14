# frozen_string_literal: true

class ChallengesController < ApplicationController
  before_action :check_competition_start!, only: %i[show entries entries_table]
  before_action :check_competition_index_landing_page!,
    :preferred_index_view, only: %i[index table]
  before_action :check_competition_landing_page_index!, only: :landing_page

  def index
    @regions = @competition.regions
      .order(:category, :name)
      .preload(approved_challenges: %i[sponsors_with_logos published_entries])
    @checker = ShowChallengesChecker.new @competition
  end

  def table
    @challenges = @competition.challenges.approved
      .order(:name)
      .preload(:region, :sponsors, :published_entries)
    @checker = ShowChallengesChecker.new @competition
    respond_to do |format|
      format.html
      format.csv { send_data @challenges.to_csv @competition }
    end
  end

  def landing_page
    @event = user_signed_in? && current_user.participating_competition_event(@competition)
    return unless (@started = @competition.started?(FIRST_COMPETITION_TIME_ZONE))

    @regions = @competition.regions
  end

  def show
    @data_sets = @challenge.data_sets
    @sponsors = @challenge.sponsors.with_attached_logo

    @user_eligible_teams = @challenge.eligible_teams & current_user.joined_teams if user_signed_in?
  end

  def entries
    @teams = @challenge.published_teams.with_attached_thumbnail
      .preload(:event, :current_project)
  end

  def entries_table
    @challenges = @competition.challenges.approved
    if @competition.either_judging_window_open?(LAST_COMPETITION_TIME_ZONE)
      judging_view
    else
      checkpoint_entry_view
    end
  end

  private

  def check_competition_index_landing_page!
    return unless show_landing_page?

    redirect_to landing_page_challenges_path
  end

  def check_competition_landing_page_index!
    return if show_landing_page?

    redirect_to challenges_path
  end

  def show_landing_page?
    !@competition.started?(FIRST_COMPETITION_TIME_ZONE)
  end

  def check_competition_start!
    @challenge = Challenge.find_by identifier: params[:identifier]
    @challenge = Challenge.find(params[:identifier]) if @challenge.nil?
    @region = @challenge.region
    return if @competition.started?(@region.time_zone) ||
      (@region.international? && @competition.started?(FIRST_COMPETITION_TIME_ZONE))

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
    @time_zone = @region.time_zone || FIRST_COMPETITION_TIME_ZONE
    @entries = @challenge.published_entries
      .preload(:checkpoint, project: :event)
  end

  def preferred_index_view
    cookies[:challenge_index_view] = params[:action]
  end
end
