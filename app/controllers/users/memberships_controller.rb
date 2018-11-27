class Users::MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_owner

  def destroy
    @assignment.destroy
    flash[:notice] = 'Left Team'
    redirect_to manage_account_path
  end

  private

  def user_is_owner
    @assignment = Assignment.find(params[:id])
    return if @assignment.user_id == current_user.id

    flash[:alert] = 'You do not have permission to modify this assignment'
    redirect_to root_path
  end
end
