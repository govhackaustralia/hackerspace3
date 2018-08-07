class Admin::Events::AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @event = Event.find(params[:event_id])
  end

  def new
    new_assignment
    return if params[:term].nil? || params[:term] == ''
    @user = User.find_by_email(params[:term])
    user_found if @user.present?
    search_other_fields unless @user.present?
  end

  def create
    create_new_assignment
    if @assignment.save
      flash[:notice] = "New #{@title} Assignment Added."
      redirect_to admin_event_assignments_path(@assignable)
    else
      flash.now[:notice] = @assignment.errors.full_messages.to_sentence
      render 'new'
    end
  end

  private

  def check_for_privileges
    return if current_user.event_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def new_assignment
    @assignable = Event.find(params[:event_id])
    @assignment = @assignable.assignments.new
    @title = params[:title]
  end

  def create_new_assignment
    @assignable = Event.find(params[:event_id])
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
end
