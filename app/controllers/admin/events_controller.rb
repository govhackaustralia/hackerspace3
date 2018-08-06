class Admin::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

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
      flash[:notice] = @event.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def show
    @region = Region.find(params[:region_id])
    @event = Event.find(params[:id])
    @registration = Registration.new
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
      render 'edit'
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :type, :registration_type,
                                       :capacity, :email, :twitter, :address, :accessibility, :youth_support,
                                       :parking, :public_transport, :operation_hours, :catering, :video_id,
                                       :start_time, :end_time, :place_id)
  end

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def create_new_event
    @region = Region.find(params[:region_id])
    @event = @region.events.new(event_params)
    @event.competition = Competition.current
  end
end
