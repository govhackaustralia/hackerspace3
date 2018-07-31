class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find_by_identifier(params[:event_identifier])
    @region = @event.region
    @registration = @event.registrations.new
    @user = current_user
  end

  def show
    @event = Event.find_by_identifier(params[:event_identifier])
    @region = @event.region
    @registration = Registration.find(params[:id])
    @event_assignment = current_user.event_assignment
    @user = current_user
  end

  def edit
    @event = Event.find_by_identifier(params[:event_identifier])
    @region = @event.region
    @registration = Registration.find(params[:id])
    @user = current_user
  end

  def update
    update_registration
    update_user_preferences
    if @registration.save
      flash[:notice] = 'Your registration has been updated'
      redirect_to event_registration_path(@event.identifier, @registration)
    else
      flash[:notice] = @registration.errors.full_messages.to_sentence
      render edit_event_registration_path(@event.identifier, @registration)
    end
  end

  def create
    create_new_registration
    update_user_preferences
    if @registration.save
      handle_new_save
    else
      flash[:notice] = @registration.errors.full_messages.to_sentence
      render 'new'
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:status)
  end

  def handle_new_save
    flash[:notice] = if params[:status] == ATTENDING
                       'You have registered for this event.'
                     else
                       'You have been added to the waitlist.'
                     end
    redirect_to event_registration_path(@event.identifier, @registration)
  end

  def create_new_registration
    @event = Event.find(params[:event_identifier])
    @registration = @event.registrations.new(status: params[:status])
    @user = current_user
    @registration.update(assignment: @user.event_assignment)
  end

  def update_registration
    @event = Event.find(params[:event_identifier])
    @registration = Registration.find(params[:id])
    @registration.update(registration_params)
    @user = current_user
  end

  def update_user_preferences
    @user.update(preferred_name: params[:preferred_name])
    @user.update(organisation_name: params[:organisation_name])
    @user.update(dietary_requirements: params[:dietary_requirements])
  end
end
