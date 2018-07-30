class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find(params[:event_id])
    @region = @event.region
    @registration = @event.registrations.new
  end

  def show
    @event = Event.find(params[:event_id])
    @region = @event.region
    @registration = Registration.find(params[:id])
    @event_assignment = current_user.event_assignment
    @user = current_user
  end

  def edit
    @event = Event.find(params[:event_id])
    @region = @event.region
    @registration = Registration.find(params[:id])
  end

  def update
    @event = Event.find(params[:event_id])
    @registration = Registration.find(params[:id])
    @registration.update(registration_params)
    if @registration.save
      flash[:notice] = 'Your registration has been updated'
      redirect_to event_registration_path(@event, @registration)
    else
      flash[:notice] = @registration.errors.full_messages.to_sentence
      render edit_event_registration_path(@event, @registration)
    end
  end

  def create
    @event = Event.find(params[:event_id])
    @region = @event.region
    @registration = @event.registrations.new(registration_params)
    @registration.update(assignment: current_user.event_assignment)
    if @registration.save
      flash[:notice] = 'You have registered for this event.'
      redirect_to event_registration_path(@event, @registration)
    else
      flash[:notice] = @registration.errors.full_messages.to_sentence
      render 'new'
    end
  end

  private

  def registration_params
    params.require(:registration).permit(:status)
  end
end
