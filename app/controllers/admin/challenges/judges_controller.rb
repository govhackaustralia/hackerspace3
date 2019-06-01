class Admin::Challenges::JudgesController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def new
    @title = JUDGE
    return if params[:term].blank?

    @users = User.search(params[:term]).preload :challenges_judging
  end

  def create
    @judge = @challenge.assignments.judges.new assignment_params
    save_new_judge
  end

  private

  def assignment_params
    params.require(:assignment).permit :user_id
  end

  def check_for_privileges
    @challenge = Challenge.find params[:challenge_id]
    return if current_user.region_privileges? @challenge.competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def save_new_judge
    if @judge.save
      flash[:notice] = 'New judge assigned'
      redirect_to admin_region_challenge_path @challenge.region_id, @challenge
    else
      @judge.errors.full_messages.to_sentence
      render :new
    end
  end
end
