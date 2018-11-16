class Admin::AssignmentsController < ApplicationController
  before_action :authenticate_user!

  private

  def handle_index
    return if current_user.privilege? @assignable.admin_assignments

    redirect_no_privilege
  end

  def handle_new
    if current_user.privilege? @assignable.admin_assignments
      new_and_user_search
    else
      redirect_no_privilege
    end
  end

  def new_and_user_search
    @assignment = @assignable.assignments.new
    @title = params[:title]
    return if params[:term].blank?

    @user = User.find_by_email(params[:term])
    user_found if @user.present?
    search_other_fields unless @user.present?
  end

  def handle_create
    if current_user.privilege? @assignable.admin_assignments
      create_and_redirect
    else
      redirect_no_privilege
    end
  end

  def create_and_redirect
    create_new_assignment
    if @assignment.save
      flash[:notice] = "New #{@title} Assignment Added."
      redirect_to_index
    else
      flash.now[:alert] = @assignment.errors.full_messages.to_sentence
      render :new
    end
  end

  def create_new_assignment
    @user = User.find(params[:user_id])
    @title = params[:title]
    @assignment = @assignable.assignments.new(user: @user, title: @title)
  end

  def user_found
    @existing_assignment = @user.assignments.find_by(assignable: @assignable, title: @title)
  end

  def search_other_fields
    @users = User.search(params[:term])
  end

  def redirect_no_privilege
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
