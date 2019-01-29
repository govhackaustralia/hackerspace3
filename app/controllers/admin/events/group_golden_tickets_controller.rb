class Admin::Events::GroupGoldenTicketsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def new
    @event = Event.find params[:event_id]
    @team = Team.find_by(id: params[:term])
    team_found if @team.present?
    search_other_fields_team unless @team.present?
  end

  def create
    @event = Event.find params[:event_id]
    @registration = @event.registrations.new(registration_params)
    @registration.status = INVITED
    @registration.time_notified = Time.now.in_time_zone COMP_TIME_ZONE
    if @registration.save
      flash[:notice] = 'New Registration Added.'
      redirect_to admin_event_registrations_path @event
    else
      create_error
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:assignment_id)
  end

  def check_for_privileges
    return if current_user.event_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def search_other_fields_team
    return if params[:term].blank?

    @teams = Team.search(params[:term]).preload :current_project
  end

  def team_found
    @project = @team.current_project
    @leader = @team.team_leader
    @leader_assignment = @team.leader_assignments.first
    @existing_registration = @event.registrations.where(assignment: @team.assignments).first
    @user = @existing_registration.user unless @existing_registration.nil?
  end

  def create_error
    flash.now[:alert] = @registration.errors.full_messages.to_sentence
    render :new
  end
end
