class Users::AssignmentsController < ApplicationController
  before_action :authenticate_user!

  def update
    @assignment = Assignment.find(params[:id])
    if @assignment.title == INVITEE
      @assignment.update(title: TEAM_MEMBER)
    else
      @assignment.update(title: TEAM_LEADER)
      leader_assignment = Assignment.find_by(assignable: @assignment.assignable, user: current_user)
      leader_assignment.update(title: TEAM_MEMBER)
    end
    redirect_to project_path(@assignment.assignable.current_project)
  end

  def destroy
    @assignment = Assignment.find(params[:id])
    @assignment.destroy
    flash[:notice] = if @assignment.title == INVITEE
                       'Invitation Declined'
                     else
                       'Left Team'
                     end
    redirect_to manage_account_path
  end
end
