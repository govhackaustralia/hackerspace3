class Flights::Registrations::RegistrationFlightsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def new
    @registration_flight = @registration.registration_flights.new
    @event = @registration.event
    flight_options
  end

  def create
    @registration_flight = @registration.registration_flights.new(registration_flight_params)
    @event = @registration.event
    flight_options
    if @registration_flight.save
      flash[:notice] = 'Flight Saved'
      redirect_to event_registration_path(@event.identifier, @registration)
    else
      flash[:alert] = @registration_flight.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def registration_flight_params
    params.require(:registration_flight).permit(:flight_id)
  end

  def check_for_privileges
    @registration = Registration.find(params[:registration_id])
    return if @registration.user == current_user

    flash[:alert] = 'You are not able to add flghts to this registration.'
    redirect_to root_path
  end

  def flight_options
    @flights = if params[:direction] == INBOUND
                 @event.inbound_flights
               else
                 @event.outbound_flights
               end
  end
end
