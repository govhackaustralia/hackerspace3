class ProjectsController < ApplicationController
  def index
    @competition = Competition.current
    @teams = @competition.teams.where(published: true)
    @id_teams_projects = Team.id_teams_projects(@teams)
    @attending_events = current_user.competition_events_participating(@competition) if user_signed_in?
    respond_to do |format|
      format.html
      format.csv { send_data @teams.to_csv }
    end
  end

  def show
    @competition = Competition.current
    @current_project = Project.find_by(identifier: params[:identifier])
    @team = @current_project.team
    @checkpoints = @competition.checkpoints.order(:end_time)
    passed_checkpoint_ids = @competition.passed_checkpoint_ids(@team.time_zone)
    @challenges_to_display = Entry.where(checkpoint: passed_checkpoint_ids, team: @team).present?
    @challenges = @team.challenges
    @id_regions = Region.id_regions(Region.all)
    user_signed_in_records if user_signed_in?
  end

  private

  def user_signed_in_records
    @user = current_user
    @peoples_scorecard = PeoplesScorecard.find_by(assignment: @user.event_assignment, team: @team)
    @favourite = Favourite.find_by(assignment: @user.event_assignment, team: @team)
  end
end
