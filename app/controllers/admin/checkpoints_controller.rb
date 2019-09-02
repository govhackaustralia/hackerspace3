class Admin::CheckpointsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @checkpoints = @competition.checkpoints.preload region_limits: :region
  end

  def new
    @checkpoint = @competition.checkpoints.new
  end

  def create
    @checkpoint = @competition.checkpoints.new checkpoint_params
    if @checkpoint.save
      flash[:notice] = 'Checkpoint created.'
      redirect_to admin_competition_checkpoints_path @competition
    else
      flash[:alert] = @checkpoint.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @checkpoint = Checkpoint.find params[:id]
  end

  def update
    @checkpoint = Checkpoint.find params[:id]
    if @checkpoint.update(checkpoint_params)
      flash[:notice] = 'Checkpoint updated.'
      redirect_to admin_competition_checkpoints_path @competition
    else
      flash[:alert] = @checkpoint.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def check_for_privileges
    @competition = Competition.find params[:competition_id]
    return if current_user.admin_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def checkpoint_params
    params.require(:checkpoint).permit(
      :end_time,
      :name,
      :max_national_challenges,
      :max_regional_challenges
    )
  end
end
