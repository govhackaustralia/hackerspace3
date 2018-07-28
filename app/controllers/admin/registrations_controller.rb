class Admin::RegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @event = Event.find(params[:event_id])
  end

  def new
    new_registration
    return if params[:term].nil? || params[:term] == ''
    @user = User.find_by_email(params[:term])
    user_found if @user.present?
    search_other_fields unless @user.present?
  end

  def edit
    @event = Event.find(params[:event_id])
    @registration = Registration.find(params[:id])
    @event_assignment = @registration.assignment
  end

  def update
    @event = Event.find(params[:event_id])
    @registration = Registration.find(params[:id])
    @registration.update(registration_params)
    flash[:notice] = 'Registration Updated.'
    redirect_to admin_event_registrations_path(@event)
  end

  def create
    create_new_registration
    if @registration.save
      flash[:notice] = 'New Registration Added.'
      redirect_to admin_event_registrations_path(@event)
    else
      flash.now[:notice] = @registration.errors.full_messages.to_sentence
      @user = @assignment.user
      render 'new'
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:status)
  end

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def new_registration
    @event = Event.find(params[:event_id])
    @registration = @event.registrations.new
  end

  def create_new_registration
    @event = Event.find(params[:event_id])
    @assignment = Assignment.find(params[:assignment_id])
    @registration = @event.registrations.new(registration_params)
    @registration.update(assignment: @assignment)
    @registration.update(time_notified: params)
  end

  def user_found
    @existing_registration = @user.registrations.find_by(event: @event)
    @event_assignment = @user.event_assignment
  end

  def search_other_fields
    @users = User.search(params[:term])
  end
end
