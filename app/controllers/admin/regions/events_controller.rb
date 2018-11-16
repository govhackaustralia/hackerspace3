class Admin::Regions::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @region = Region.find(params[:region_id])
    @connection_events = @region.events.where(event_type: CONNECTION_EVENT)
    @competition_events = @region.events.where(event_type: COMPETITION_EVENT)
    @award_events = @region.events.where(event_type: AWARD_EVENT)
  end

  def new
    @region = Region.find(params[:region_id])
    @event = @region.events.new
  end

  def create
    create_new_event
    if @event.save
      flash[:notice] = 'New event created.'
      redirect_to admin_region_event_path(@region, @event)
    else
      flash[:alert] = @event.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    @region = Region.find(params[:region_id])
    @event = Event.find(params[:id])
    @registration = Registration.new
    return unless @region.national? && @event.event_type == AWARD_EVENT

    @inbound_flights = @event.inbound_flights
    @outbound_flights = @event.outbound_flights
    @bulk_mails = @event.bulk_mails
  end

  def edit
    @region = Region.find(params[:region_id])
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      redirect_to admin_region_event_path(@event.region_id, @event)
    else
      flash[:alert] = @event.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def check_for_privileges
    return if current_user.region_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def event_params
    params.require(:event).permit(:name, :event_type, :registration_type,
                                  :capacity, :email, :twitter, :address,
                                  :accessibility, :youth_support, :parking,
                                  :public_transport, :operation_hours,
                                  :catering, :video_id, :start_time, :end_time,
                                  :place_id, :description, :published)
  end

  def create_new_event
    @region = Region.find(params[:region_id])
    @event = @region.events.new(event_params)
    @event.competition = Competition.current
  end
end
