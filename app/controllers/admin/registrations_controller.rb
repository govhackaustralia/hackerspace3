class Admin::RegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @event = Event.find params[:event_id]
    @region = @event.region
    respond_to do |format|
      format.html
      format.csv { send_data @event.registrations_to_csv }
    end
  end

  def new
    new_registration
    return if params[:term].blank?

    if params[:type] == STAFF
      new_staff
    else
      new_normal
    end
  end

  def create
    @event = Event.find params[:event_id]
    create_new_registration
    if @registration.save
      flash[:notice] = 'New Registration Added.'
      redirect_to admin_event_registrations_path @event
    else
      create_error
    end
  end

  # ENHANCEMENT: Amend view to account for other registration types in nation
  # awards.
  def edit
    @event = Event.find params[:event_id]
    @region = @event.region
    @registration = Registration.find params[:id]
    @event_assignment = @registration.assignment
    @user = @event_assignment.user
  end

  def update
    update_registration
    if @registration.update registration_params
      flash[:notice] = 'Registration Updated.'
      redirect_to admin_event_registrations_path @event
    else
      update_error
    end
  end

  private

  # ENHANCEMENT: Add assignment_id to registration_params
  def registration_params
    params.require(:registration).permit(:status)
  end

  def create_error
    flash.now[:alert] = @registration.errors.full_messages.to_sentence
    @user = @assignment.user
    @event_assignment = @user.event_assignment
    render :new
  end

  def update_error
    flash.now[:alert] = @registration.errors.full_messages.to_sentence
    @user = @registration.user
    @event_assignment = @user.event_assignment
    @event = @registration.event
    @region = @event.region
    render :edit
  end

  def new_staff
    @assignment = Assignment.find(params[:term]) unless params[:term].to_i.zero?
    @user = @assignment.user unless @assignment.nil?
    complete_new_staff
  end

  def complete_new_staff
    search_other_fields unless @user.present?
    staff_found if @user.present?
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

  # ENHANCEMENT: Break into seperate controllers.
  def create_new_registration
    if params[:type] == INDIVIDUAL_GOLDEN
      create_individual_golden
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

  def staff_found
    @existing_registration = Registration.find_by(assignment: @assignment, event: @event)
  end

  def search_other_fields
    @users = User.search(params[:term]).preload :assignments
  end

  def update_registration
    @event = Event.find params[:event_id]
    @registration = Registration.find params[:id]
  end
end
