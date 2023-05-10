# frozen_string_literal: true

class Users::InvitationsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_is_owner

  def update
    @assignment.update title: TEAM_MEMBER
    @team = @assignment.assignable
    flash[:notice] = "Welcome to #{@team.name}"
    redirect_to team_management_team_path @team
  end

  def destroy
    @assignment.destroy
    flash[:notice] = 'Invitation Declined'
    redirect_to manage_account_path
  end

  private

  def user_is_owner
    @assignment = Assignment.find params[:id]
    return if @assignment.user_id == current_user.id

    flash[:alert] = 'You do not have permission to modify this assignment'
    redirect_to root_path
  end
end
