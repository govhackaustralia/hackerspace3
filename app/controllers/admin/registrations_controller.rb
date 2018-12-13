class Admin::RegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @event = Event.find(params[:event_id])
    @region = @event.region
    respond_to do |format|
      format.html
      format.csv { send_data @event.registrations_to_csv }
    end
  end

  def new
    new_registration
    return if params[:term].blank?

    if params[:type] == GROUP_GOLDEN
      new_golden_group
    elsif params[:type] == STAFF
      new_staff
    else
      new_normal
    end
  end

  def edit
    @event = Event.find(params[:event_id])
    @region = @event.region
    @registration = Registration.find(params[:id])
    @event_assignment = @registration.assignment
    @user = @event_assignment.user
  end

  def update
    update_registration
    if @registration.update(registration_params)
      flash[:notice] = 'Registration Updated.'
      redirect_to admin_event_registrations_path(@event)
    else
      flash.now[:alert] = @registration.errors.full_messages.to_sentence
      render :edit
    end
  end

  def create
    @event = Event.find(params[:event_id])
    create_new_registration
    if @registration.save
      flash[:notice] = 'New Registration Added.'
      redirect_to admin_event_registrations_path(@event)
    else
      create_error
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:status)
  end

  def create_error
    flash.now[:alert] = @registration.errors.full_messages.to_sentence
    @user = @assignment.user
    render :new
  end

  def new_golden_group
    @team = Team.find(params[:term]) unless params[:term].to_i.zero?
    team_found if @team.present?
    search_other_fields_team unless @team.present?
  end

  def new_staff
    @assignment = Assignment.find(params[:term]) unless params[:term].to_i.zero?
    @user = @assignment.user unless @assignment.nil?
    complete_new_staff
  end

  def complete_new_staff
    search_other_fields unless @user.present?
    staff_found if @user.present?
    @user_id_assignments = Assignment.user_id_assignments(@users) if @users.present?
  end

  def check_for_privileges
    return if current_user.event_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def new_registration
    @event = Event.find(params[:event_id])
    @registration = @event.registrations.new
  end

  def new_normal
    @user = User.find_by_email(params[:term])
    user_found if @user.present?
    search_other_fields unless @user.present?
  end

  def create_new_registration
    if params[:type] == INDIVIDUAL_GOLDEN
      create_individual_golden
    elsif params[:type] == GROUP_GOLDEN
      create_group_golden
    elsif params[:type] == STAFF
      create_staff
    else
      create_normal
    end
    finish_create
  end

  def create_individual_golden
    user = User.find(params[:user_id])
    @assignment = Assignment.find_or_create_by(user: user, title: GOLDEN_TICKET, assignable: Competition.current)
    @registration = @event.registrations.new(status: INVITED)
  end

  def create_group_golden
    @team = Team.find(params[:team_id])
    @assignment = @team.assignments.where(title: TEAM_LEADER).first
    @registration = @event.registrations.new(status: INVITED)
  end

  def create_staff
    @assignment = Assignment.find(params[:assignment_id])
    @registration = @event.registrations.new(status: INVITED)
  end

  def create_normal
    @assignment = Assignment.find(params[:assignment_id])
    @registration = @event.registrations.new(registration_params)
  end

  def finish_create
    @registration.update(assignment: @assignment)
    @registration.update(time_notified: Time.now.in_time_zone(COMP_TIME_ZONE))
  end

  def user_found
    @existing_registration = @user.registrations.find_by(event: @event)
    @event_assignment = @user.event_assignment
  end

  def team_found
    @project = @team.current_project
    assignment = @team.assignments.where(title: TEAM_LEADER).first
    @leader = assignment.user unless assignment.nil?
    @existing_registration = @event.registrations.where(assignment: @team.assignments).first
    @user = @existing_registration.user unless @existing_registration.nil?
  end

  def staff_found
    @existing_registration = Registration.find_by(assignment: @assignment, event: @event)
  end

  def search_other_fields
    @users = User.search(params[:term])
  end

  def search_other_fields_team
    @teams = Team.search(params[:term]).preload(:current_project)
  end

  def update_registration
    @event = Event.find(params[:event_id])
    @registration = Registration.find(params[:id])
  end
end
