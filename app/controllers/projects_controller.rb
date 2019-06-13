class ProjectsController < ApplicationController
  def index
    index_variables
    user_records_index if user_signed_in?
    respond_to do |format|
      format.html
      format.csv { send_data @teams.to_csv }
    end
  end

  def show
    @team = Project.find_by(identifier: params[:identifier]).team
    @current_project = @team.current_project
    if @team.published
      show_published
    else
      flash[:alert] = 'This Team Project has not been published.'
      redirect_to root_path
    end
  end

  private

  def index_variables
    @teams = @competition.teams.published
    @projects = @competition.published_projects_by_name.preload(:event)
    @region_privileges = user_signed_in? && current_user.region_privileges?(@competition)
  end

  def show_published
    @checkpoints = @competition.checkpoints.order(:end_time)
    @passed_checkpoint_ids = @competition.passed_checkpoint_ids(@team.time_zone)
    @entries_to_display = @team.entries.where(checkpoint: @passed_checkpoint_ids).preload(challenge: :region)
    user_records_show if user_signed_in?
  end

  def user_records_index
    retrieve_attending_events
    return unless @competition.in_peoples_judging_window? LAST_TIME_ZONE
    return unless (@peoples_assignment = current_user.peoples_assignment(@competition)).present?

    @judgeable_assignment = current_user.judgeable_assignment @competition
    @project_judging = @judgeable_assignment.judgeable_scores(@teams)
    @project_judging_total = @competition.score_total PROJECT
  end

  def retrieve_attending_events
    return unless @competition.not_finished? LAST_TIME_ZONE

    @attending_events = current_user.participating_competition_events.competition(@competition)
  end

  def user_records_show
    @user = current_user
    @favourite = Favourite.find_by(assignment: @user.event_assignment(@competition), team: @team)
    @scorecard = Scorecard.find_by(assignment: @user.event_assignment(@competition), judgeable: @team)
    @judgeable_assignment = @user.judgeable_assignment @competition
    @peoples_assignment = @user.peoples_assignment @competition
    @judge = @user.judge_assignment(@team.challenges)
    @users_team = @user.joined_teams.include? @team
  end
end
