class Admin::Users::AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def edit
    existing_user_and_assignment
  end

  def update
    existing_user_and_assignment
    if params[:assignment][:title] == PARTICIPANT && @assignment.title == VIP
      cannot_demote_vip
    else
      @assignment.update(assignment_params)
      flash[:notice] = 'User event assignment has bee updated'
      redirect_to admin_user_path(@user)
    end
  end

  private

  def assignment_params
    params.require(:assignment).permit(:title)
  end

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def existing_user_and_assignment
    @user = User.find(params[:user_id])
    @assignment = Assignment.find(params[:id])
  end

  def cannot_demote_vip
    flash.now[:notice] = 'Apologies, event assignments cannot be reverted to Particpant'
    render 'edit'
  end
end
