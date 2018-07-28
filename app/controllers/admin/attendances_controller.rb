class Admin::AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @event = Event.find(params[:event_id])
  end

  def new
    new_attendance
    return if params[:term].nil? || params[:term] == ''
    @user = User.find_by_email(params[:term])
    user_found if @user.present?
    search_other_fields unless @user.present?
  end

  def edit
    @event = Event.find(params[:event_id])
    @attendance = Attendance.find(params[:id])
    @event_assignment = @attendance.assignment
  end

  def update
    @event = Event.find(params[:event_id])
    @attendance = Attendance.find(params[:id])
    @attendance.update(attendance_params)
    flash[:notice] = 'Registration Updated.'
    redirect_to admin_event_attendances_path(@event)
  end

  def create
    create_new_attendance
    if @attendance.save
      flash[:notice] = 'New Registration Added.'
      redirect_to admin_event_attendances_path(@event)
    else
      flash.now[:notice] = @attendance.errors.full_messages.to_sentence
      @user = @assignment.user
      render 'new'
    end
  end

  private

  def attendance_params
    params.require(:attendance).permit(:status)
  end

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def new_attendance
    @event = Event.find(params[:event_id])
    @attendance = @event.attendances.new
  end

  def create_new_attendance
    @event = Event.find(params[:event_id])
    @assignment = Assignment.find(params[:assignment_id])
    @attendance = @event.attendances.new(attendance_params)
    @attendance.update(assignment: @assignment)
    @attendance.update(time_notified: params)
  end

  def user_found
    @existing_attendance = @user.attendances.find_by(event: @event)
    @event_assignment = @user.event_assignment
  end

  def search_other_fields
    @users = User.search(params[:term])
  end
end
