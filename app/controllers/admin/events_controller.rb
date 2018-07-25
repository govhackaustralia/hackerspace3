class Admin::EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def new
    @region = Region.find(params[:region_id])
    @event = @region.events.new
    @event.competition = Competition.current
  end

  def create
    @region = Region.find(params[:region_id])
    @event = @region.events.new(event_params)
    @event.competition = Competition.current
    if @event.save
      redirect_to admin_region_event_path(@region, @event)
    else
      render new_admin_region_event_path(@region, @event)
    end
  end

  def show
    @region = Region.find(params[:region_id])
    @event = Event.find(params[:id])
    @attendance = Attendance.new
  end

  private

  def event_params
    params.require(:event).permit(:name)
  end

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
