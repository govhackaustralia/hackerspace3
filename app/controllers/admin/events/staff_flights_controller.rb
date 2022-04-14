class Admin::Events::StaffFlightsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def new
    @registration = @event.registrations.new
    @competition = @event.competition
    search_for_staff unless params[:term].blank?
  end

  def create
    new_registration
    if @registration.save
      flash[:notice] = 'New Registration Added.'
      redirect_to admin_event_registrations_path @event
    else
      create_error
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:assignment_id, :holder_id)
  end

  def check_for_privileges
    @event = Event.find params[:event_id]
    return if current_user.event_privileges? @event.competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def search_for_staff
    @assignment = Assignment.find_by id: params[:term]
    search_other_fields unless @assignment.present?
    staff_found if @assignment.present?
  end

  def search_other_fields
    @users = User.search(params[:term]).preload :staff_assignments
  end

  def staff_found
    @user = @assignment.user
    @existing_registration = @user.registrations.find_by event: @event
  end

  def new_registration
    @registration = @event.registrations.invited.new registration_params
    @registration.time_notified = Time.now.in_time_zone LAST_COMPETITION_TIME_ZONE
  end

  def create_error
    flash.now[:alert] = @registration.errors.full_messages.to_sentence
    @user = @registration.user
    render :new
  end
end
