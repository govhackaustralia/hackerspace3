class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find_by(identifier: params[:event_identifier])
    @region = @event.region
    @registration = @event.registrations.new
    @user = current_user
  end

  def show
    @user = current_user
    @event_assignment = @user.event_assignment
    @registration = Registration.find(params[:id])
    @event = @registration.event
    @region = @event.region
  end

  def edit
    @registration = Registration.find(params[:id])
    @event = @registration.event
    @region = @event.region
    @user = current_user
  end

  def update
    update_registration
    update_user_preferences
    if @registration.save
      flash[:notice] = 'Your registration has been updated'
      redirect_to event_registration_path(@event.identifier, @registration)
    else
      flash[:alert] = @registration.errors.full_messages.to_sentence
      render :edit
    end
  end

  def create
    create_new_registration
    update_user_preferences
    if @registration.save
      handle_new_save
    else
      flash[:alert] = @registration.errors.full_messages.to_sentence
      render :new
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
    @registration.update(assignment: @user.event_assignment, time_notified: Time.now)
  end

  def update_registration
    @registration = Registration.find(params[:id])
    @event = @registration.event
    @registration.update(registration_params)
    @registration.update(time_notified: Time.now)
    @user = current_user
  end

  def update_user_preferences
    @user.update(preferred_name: params[:preferred_name])
    @user.update(organisation_name: params[:organisation_name])
    @user.update(dietary_requirements: params[:dietary_requirements])
  end
end
