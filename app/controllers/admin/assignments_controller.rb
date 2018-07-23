class Admin::AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index; end

  def new; end

  private

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
