class AttendancesController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find(params[:event_id])
    @attendance = @event.attendances.new
  end

  def create
    @event = Event.find(params[:event_id])
    @assignment = current_user.event_assignment
    @attendance = @event.attendances.create(assignment: @assignment,
                                            status: params[:attendance][:status],
                                            time_notified: Time.now)
    flash[:notice] = if @attendance.persisted?
                       'Thanks for registering, see you at the event!'
                     else
                       'Apologies but we could not add you at this time.'
                     end
    redirect_to event_path(@event)
  end
end
