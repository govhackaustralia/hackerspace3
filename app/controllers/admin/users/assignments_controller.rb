# frozen_string_literal: true

class Admin::Users::AssignmentsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def destroy
    existing_user_and_assignment
    @assignment.destroy
    redirect_to admin_user_path @user
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges? Competition.all

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def existing_user_and_assignment
    @user = User.find params[:user_id]
    @assignment = Assignment.find params[:id]
  end
end
