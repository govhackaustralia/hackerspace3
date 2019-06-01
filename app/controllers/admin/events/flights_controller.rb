class Admin::Events::FlightsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @region = @event.region
    @inbound_flights = @event.inbound_flights
    @outbound_flights = @event.outbound_flights
  end

  def new
    @flight = @event.flights.new
  end

  def create
    @flight = @event.flights.new flight_params
    if @flight.save
      flash[:notice] = 'New Flight Created'
      redirect_to admin_event_flights_path @event
    else
      flash[:alert] = @flight.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @flight = Flight.find params[:id]
  end

  def update
    @flight = Flight.find params[:id]
    @flight.update flight_params
    if @flight.save
      flash[:notice] = 'Flight Update'
      redirect_to admin_event_flights_path @event
    else
      flash[:alert] = @flight.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @flight = Flight.find params[:id]
    @flight.destroy
    flash[:notice] = 'Flight removed.'
    redirect_to admin_event_flights_path(@event)
  end

  private

  def flight_params
    params.require(:flight).permit :direction, :description
  end

  def check_for_privileges
    @event = Event.find params[:event_id]
    return if current_user.event_privileges? @event.competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
