class Admin::AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def create
    @event = Event.find(params[:event_id])
    if (@user = User.find_by_email(params[:email])).present?
      if (assignment = @user.event_assignment).title == VIP
        @attendance = @event.attendances.find_or_create_by(assignment: assignment)
        @attendance.update(status: params[:status])
        flash[:notice] = if @attendance.save
                           'New VIP member Added.'
                         else
                           'Apologies, Something went wrong'
                         end
      else
        flash[:notice] = 'User not currently a VIP, please assign in User Management'
      end
    else
      flash[:notice] = 'Email address not found.'
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
