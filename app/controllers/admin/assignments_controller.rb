class Admin::AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index; end

  def create
    if (@user = User.find_by(email: params[:email])).present?
      @user.make_management_team
      flash[:notice] = 'New Management Team Member Added.'
    else
      flash[:notice] = 'Email address not found.'
    end
    redirect_to competition_management_path
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
