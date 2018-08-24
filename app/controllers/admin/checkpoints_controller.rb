class Admin::CheckpointsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @competition = Competition.find(params[:competition_id])
    @checkpoints = @competition.checkpoints
  end

  def new
    @competition = Competition.find(params[:competition_id])
    @checkpoint = @competition.checkpoints.new
  end

  def create
    create_new_checkpoint
    if @checkpoint.save
      flash[:notice] = 'Checkpoint created.'
      redirect_to admin_competition_checkpoints_path(@competition)
    else
      flash[:alert] = @checkpoint.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @competition = Competition.find(params[:competition_id])
    @checkpoint = Checkpoint.find(params[:id])
  end

  def update
    retrieve_competition_and_checkpoint
    if @checkpoint.update(checkpoint_params)
      flash[:notice] = 'Checkpoint updated.'
      redirect_to admin_competition_checkpoints_path(@competition)
    else
      flash[:alert] = @checkpoint.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def checkpoint_params
    params.require(:checkpoint).permit(:end_time, :name,
                                       :max_national_challenges,
                                       :max_regional_challenges)
  end

  def retrieve_competition_and_checkpoint
    @competition = Competition.find(params[:competition_id])
    @checkpoint = Checkpoint.find(params[:id])
  end

  def create_new_checkpoint
    @competition = Competition.find(params[:competition_id])
    @checkpoint = @competition.checkpoints.new(checkpoint_params)
  end
end
