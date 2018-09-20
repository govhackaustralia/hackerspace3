class ProjectsController < ApplicationController
  def index
    @competition = Competition.current
    @teams = @competition.teams.where(published: true)
    @id_teams_projects = Team.id_teams_projects(@teams)
    @projects = Team.projects_by_name(@id_teams_projects)
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
      @competition = Competition.current
      @checkpoints = @competition.checkpoints.order(:end_time)
      @passed_checkpoint_ids = @competition.passed_checkpoint_ids(@team.time_zone)
      @entries_to_display = Entry.where(checkpoint: @passed_checkpoint_ids, team: @team)
      @challenges = @team.challenges
      @id_regions = Region.id_regions(Region.all)
      user_records_show if user_signed_in?
    else
      flash[:alert] = 'This Team Project has not been published.'
      redirect_to root_path
    end
  end

  private

  def user_records_index
    if @competition.not_finished?(LAST_TIME_ZONE)
      @attending_events = current_user.competition_events_participating(@competition)
    end
    if @competition.in_peoples_judging_window?(LAST_TIME_ZONE)
      if (@judgeable_assignment = current_user.judgeable_assignment).present?
        @project_judging = @judgeable_assignment.judgeable_scores(@teams)
        @project_judging_total = @competition.score_total PROJECT
      end
    end
  end

  def user_records_show
    @user = current_user
    @favourite = Favourite.find_by(assignment: @user.event_assignment, team: @team)
    @scorecard = Scorecard.find_by(assignment: @user.event_assignment, judgeable: @team)
    @judgeable_assignment = @user.judgeable_assignment
    @peoples_assignment = @user.peoples_assignment
    @judge = @user.judge_assignment(@team.challenges)
    @not_own_team = !@user.in_team?(@team)
  end
end
