class TeamManagement::Teams::AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_team_privileges!

  def index; end

  def new
    new_assignment
    return if params[:term].blank?

    @user = User.find_by_email(params[:term])
    search_user_competition_event if @user.present?
    search_for_existing_assignment if @user.present?
    search_other_fields unless @user.present?
  end

  def create
    create_new_assignment
    if @assignment.save
      flash[:notice] = "New #{params[:title]} Assignment Added."
      redirect_to team_management_team_assignments_path(@team)
    else
      flash.now[:alert] = @assignment.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.update(title: TEAM_LEADER)
      flash[:notice] = 'New Team Leader Assigned'
    else
      flash[:alert] = @assignment.errors.full_messages.to_sentence
    end
    redirect_to team_management_team_assignments_path(@team)
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy
    flash[:notice] = 'Assignment Removed'
    redirect_to team_management_team_assignments_path(@team)
  end

  private

  def check_user_team_privileges!
    @team = Team.find(params[:team_id])
    @competition = @team.competition
    return if @team.permission?(current_user) && @competition.in_competition_window?(@team.time_zone)

    if @team.permission?(current_user)
      flash[:notice] = 'The competition has closed.'
      redirect_to project_path(@team.current_project.identifier)
    else
      flash[:notice] = 'You do not have access permissions for this team.'
      redirect_to root_path
    end
  end

  def new_assignment
    @team = Team.find(params[:team_id])
    @assignment = @team.assignments.new
    @title = params[:title]
  end

  def create_new_assignment
    @user = User.find(params[:user_id])
    @assignment = @team.assignments.new(user: @user, title: INVITEE)
  end

  def search_other_fields
    @users = User.search(params[:term])
  end

  def search_for_existing_assignment
    @existing_assignment = @user.assignments.find_by(assignable: @team, title: [TEAM_LEADER, TEAM_MEMBER, INVITEE])
  end

  def search_user_competition_event
    event_ids = Registration.where(status: [ATTENDING, WAITLIST], assignment: @user.event_assignment).pluck(:event_id)
    @participating_events = Event.where(event_type: COMPETITION_EVENT, id: event_ids)
  end
end
