class TeamManagement::Teams::AssignmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @team = Team.find(params[:team_id])
  end

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
      redirect_to team_management_team_assignments_path(@assignable)
    else
      flash.now[:alert] = @assignment.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @assignment = Assignment.find(params[:id])
    old_title = @assignment.title
    @team = @assignment.assignable
    @assignment.update(title: params[:title])
    if @assignment.save
      if old_title == INVITEE
        flash[:notice] = "Welcome to #{@team.name}"
        redirect_to team_management_team_path(@team)
      elsif old_title == TEAM_MEMBER && params[:title] == TEAM_LEADER
        flash[:notice] = 'New Team Leader Assigned'
        redirect_to team_management_team_assignments_path(@team)
      else
        flash[:notice] = 'Assignment Updated'
        redirect_to team_management_team_assignments_path(@team)
      end
    else
      flash[:alert] = @assignment.errors.full_messages.to_sentence
      redirect_to team_management_team_assignments_path(@team)
    end
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    @team = @assignment.assignable
    @assignment.destroy
    flash[:notice] = 'Assignment Removed'
    redirect_to team_management_team_assignments_path(@team)
  end

  private

  def new_assignment
    @assignable = Team.find(params[:team_id])
    @assignment = @assignable.assignments.new
    @title = params[:title]
  end

  def create_new_assignment
    @assignable = Team.find(params[:team_id])
    @user = User.find(params[:user_id])
    @assignment = @assignable.assignments.new(user: @user, title: params[:title])
  end

  def search_other_fields
    @users = User.search(params[:term])
  end

  def search_for_existing_assignment
    @existing_assignment = @user.assignments.find_by(assignable: @assignable, title: [TEAM_LEADER, TEAM_MEMBER, INVITEE])
  end

  def search_user_competition_event
    event_ids = Registration.where(status: ATTENDING, assignment: @user.event_assignment).pluck(:event_id)
    @participating_events = Event.where(event_type: COMPETITION_EVENT, id: event_ids)
  end
end
