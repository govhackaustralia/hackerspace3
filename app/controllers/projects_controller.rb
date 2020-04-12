class ProjectsController < ApplicationController
  before_action :check_competition_started!, :check_team_published!, only: :show

  def index
    @teams = @competition.teams.published
    @projects = @competition.published_projects_by_name.preload :event
    user_records_index if user_signed_in?
    respond_to do |format|
      format.html
      format.csv { send_data @teams.to_csv @competition }
    end
  end

  def show
    @current_project = @team.current_project
    @checkpoints = @competition.checkpoints.order :end_time
    @passed_checkpoint_ids = @competition.passed_checkpoint_ids @time_zone
    @entries_to_display = @team.entries.where(
      checkpoint: @passed_checkpoint_ids
    ).preload challenge: :region
    user_records_show if user_signed_in?
  end

  private

  def user_records_index
    retrieve_attending_events
    return unless @competition.in_peoples_judging_window? LAST_TIME_ZONE
    return unless (@peoples_assignment = current_user.peoples_assignment(@competition)).present?

    @judgeable_assignment = current_user.judgeable_assignment @competition
    @project_judging = JudgeableScores.new(@judgeable_assignment, @teams).compile
    @project_judging_total = @competition.score_total PROJECT
  end

  def retrieve_attending_events
    return unless @competition.in_form_or_comp_window? LAST_TIME_ZONE

    @participating_competition_event = current_user.participating_competition_event @competition
    return unless @participating_competition_event.present?

    @time_zone = @participating_competition_event.region.time_zone
  end

  def user_records_show
    @user = current_user
    retrieve_favourite_and_scorecard
    @judgeable_assignment = @user.judgeable_assignment @competition
    @peoples_assignment = @user.peoples_assignment @competition
    @judge = @user.judge_assignment(@team.challenges)
    @users_team = @user.joined_teams.include? @team
  end

  def retrieve_favourite_and_scorecard
    @favourite = Favourite.find_by(
      assignment: @user.event_assignment(@competition),
      team: @team
    )
    @header= Header.find_by(
      assignment: @user.event_assignment(@competition),
      scoreable: @team
    )
  end

  def check_competition_started!
    @team = Project.find_by(identifier: params[:identifier]).team
    @time_zone = @team.time_zone
    return if @competition.started? @time_zone

    flash[:alert] = 'Teams will become visible at the start of the competition'
    redirect_to projects_path
  end

  def check_team_published!
    return if @team.published

    flash[:alert] = 'This Team Project has not been published.'
    redirect_to projects_path
  end
end
