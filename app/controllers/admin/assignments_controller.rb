class Admin::AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def create
    if (@user = User.find_by(email: params[:email])).present?
      @user.assignments.find_or_create_by(title: params[:title],
                                          assignable_type: params[:assignable_type],
                                          assignable_id: params[:assignable_id])
      flash[:notice] = "New #{params[:title]} member Added."
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
