class Admin::CompetitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @competition = Competition.current
  end

  def show
    @competition = Competition.find(params[:id])
    @checkpoints = @competition.checkpoints
  end

  def edit
    @competition = Competition.find(params[:id])
  end

  def update
    @competition = Competition.find(params[:id])
    if @competition.update(competition_params)
      flash[:notice] = 'Competition Times update.'
      redirect_to admin_competition_path(@competition)
    else
      flash[:alert] = @competition.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def competition_params
    params.require(:competition).permit(:end_time, :start_time)
  end

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
