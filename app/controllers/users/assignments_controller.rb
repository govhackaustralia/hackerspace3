class Users::AssignmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @assignment = Assignment.find(params[:id])
    if @assignment.user == current_user
      @assignment.destroy
      flash[:notice] = if @assignment.title == INVITEE
                         'Invitation Declined'
                       else
                         'Left Team'
                       end
      redirect_to manage_account_path
    else
      redirect_to root_path
    end
  end
end
