class TeamManagement::Teams::AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_team_privileges!

  # IMPROVEMENT: Move DB calls into the controller.
  def index; end

  def new
    @team = Team.find params[:team_id]
    search_for_user unless params[:term].blank?
  end

  def create
    new_invitee_assignment
    if @assignment.save
      flash[:notice] = "New #{params[:title]} Assignment Added."
      redirect_to team_management_team_assignments_path @team
    else
      flash.now[:alert] = @assignment.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @assignment = Assignment.find params[:id]
    if @assignment.update title: TEAM_LEADER
      flash[:notice] = 'New Team Leader Assigned'
    else
      flash[:alert] = @assignment.errors.full_messages.to_sentence
    end
    redirect_to team_management_team_assignments_path @team
  end

  def destroy
    @assignment = Assignment.find params[:id]
    @assignment.destroy
    flash[:notice] = 'Assignment Removed'
    redirect_to team_management_team_assignments_path(@team)
  end

  private

  # IMPROVEMENT - Multiple move up to ApplicationController
  def check_user_team_privileges!
    @team = Team.find params[:team_id]
    @competition = @team.competition
    return if @team.permission?(current_user) && @competition.in_window?(@team.time_zone)

    check_team_permission
  end

  def search_for_user
    @user = User.find_by_id params[:term]
    search_user_competition_event if @user.present?
    search_for_existing_assignment if @user.present?
    @users = User.search(params[:term]) unless @user.present?
  end

  def check_team_permission
    if @team.permission? current_user
      flash[:notice] = 'No team editing at this time.'
      redirect_to project_path @team.current_project.identifier
    else
      flash[:notice] = 'You do not have access permissions for this team.'
      redirect_to root_path
    end
  end

  def new_invitee_assignment
    @assignment = @team.assignments.team_invitees.new assignment_params
  end

  def search_for_existing_assignment
    @existing_assignment = @user.assignments.team_participants.find_by(
      assignable: @team, competition: @competition
    )
  end

  def search_user_competition_event
    event_ids = Registration.participating.where(
      assignment: @user.event_assignment(@team.competition)
    ).pluck(:event_id)
    @participating_events = Event.competitions.where id: event_ids
  end

  def assignment_params
    params.require(:assignment).permit :user_id
  end
end
