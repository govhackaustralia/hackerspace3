class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find(params[:event_id])
    @registration = @event.registrations.find_or_create_by(assignment: current_user.event_assignment)
  end

  def edit
    @event = Event.find(params[:event_id])
    @registration = Registration.find(params[:id])
  end

  def update
    @registration = Registration.find(params[:id])
    @registration.update(registration_params)
    if @registration.save
      flash[:notice] = 'Your registration has been updated'
      redirect_to event_path(@registration.event)
    else
      flash[:notice] = 'Something went wrong'
      render edit_event_registration_path(@registration.event, @registration)
    end
  end

  def create
    if @registration.save
      flash[:notice] = 'You have registered for this event.'
      redirect_to event_path(@event)
    else
      flash[:notice] = 'Apologies but we could not add you at this time.'
      redirect_to event_path(@event)
    end
  end

  private

  def create_registration
    @event = Event.find(params[:event_id])
    @assignment = current_user.event_assignment
    @registration = Registration.new(event: @event, assignment: @assignment)
    @registration.update(status: INTENDING)
    @registration.update(time_notified: Time.now)
  end

  def registration_params
    params.require(:registration).permit(:status)
  end
end
