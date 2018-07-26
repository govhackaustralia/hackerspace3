class AttendancesController < ApplicationController
  before_action :authenticate_user!

  def new
    @event = Event.find(params[:event_id])
    @attendance = @event.attendances.find_or_create_by(assignment: current_user.event_assignment)
  end

  def edit
    @event = Event.find(params[:event_id])
    @attendance = Attendance.find(params[:id])
  end

  def update
    @attendance = Attendance.find(params[:id])
    @attendance.update(attendance_params)
    if @attendance.save
      flash[:notice] = 'Your attendance has been updated'
      redirect_to event_path(@attendance.event)
    else
      flash[:notice] = 'Something went wrong'
      render edit_event_attendance_path(@attendance.event, @attendance)
    end
  end

  def create
    @event = Event.find(params[:event_id])
    @assignment = current_user.event_assignment
    @attendance = Attendance.find_or_create_by(event: @event, assignment: @assignment)
    @attendance.update(attendance_params)
    @attendance.update(time_notified: Time.now)
    flash[:notice] = if @attendance.persisted?
                       'Thanks for registering, see you at the event!'
                     else
                       'Apologies but we could not add you at this time.'
                     end
    redirect_to event_path(@event)
  end

  private

  def attendance_params
    params.require(:attendance).permit(:status)
  end
end
