class Admin::Regions::EventsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @events = @region.events
  end

  def show
    @event = Event.find params[:id]
    return unless @region.international? && @event.event_type == AWARD_EVENT

    @inbound_flights = @event.inbound_flights
    @outbound_flights = @event.outbound_flights
    @bulk_mails = @event.bulk_mails
  end

  def preview
    @event = Event.find params[:id]
    @event_partners = @event.event_partners
    @sponsorship_types = @region.sponsorship_types.distinct.order position: :asc
    @user = current_user
    @event_assignment = @user.event_assignment(@competition)
    @registration = Registration.find_by(
      event: @event,
      assignment: @event_assignment
    )
    render 'events/show'
  end

  # ENHANCEMENT: Remove break tags from form.
  def new
    @event = @region.events.new
  end

  def create
    @event = @region.events.new event_params
    if @event.save
      flash[:notice] = 'New event created.'
      redirect_to admin_region_event_path @region, @event
    else
      flash[:alert] = @event.errors.full_messages.to_sentence
      render :new
    end
  end

  # ENHANCEMENT: Remove break tags from form.
  def edit
    @event = Event.find params[:id]
  end

  def update
    @event = Event.find params[:id]
    if @event.update event_params
      redirect_to admin_region_event_path @event.region, @event
    else
      flash[:alert] = @event.errors.full_messages.to_sentence
      @region = @event.region
      render :edit
    end
  end

  private

  def check_for_privileges
    @region = @competition.regions.find_by_identifier params[:region_id]
    @competition = @region.competition
    return if current_user.event_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def event_params
    params.require(:event).permit(
      :name, :event_type, :registration_type, :capacity, :email, :twitter,
      :address, :accessibility, :youth_support, :parking, :public_transport,
      :operation_hours, :catering, :video_id, :start_time, :end_time, :place_id,
      :description, :published
    )
  end
end
