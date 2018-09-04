class Admin::Teams::EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def new
    @team = Team.find(params[:team_id])
    @entry = @team.entries.new
    @challenges = @team.available_challenges(params[:challenge_type])
  end

  def create
    @team = Team.find(params[:team_id])
    @entry = @team.entries.new(checkpoint_id: params[:checkpoint_id])
    @entry.update(entry_params)
    if @entry.save
      flash[:notice] = 'New Challenge Entry Created'
      redirect_to admin_team_path(@team)
    else
      @challenges = @team.available_challenges(params[:challenge_type])
      flash[:alert] = @entry.errors.full_messages.to_sentence
      render :new, challenge_type: params[:challenge_type], checkpoint_id: params[:checkpoint_id]
    end
  end

  def destroy
    @team = Team.find(params[:team_id])
    @entry = Entry.find(params[:id])
    @entry.destroy
    flash[:notice] = 'Challenge Entry Removed'
    redirect_to admin_team_path(@team)
  end

  private

  def entry_params
    params.require(:entry).permit(:challenge_id, :justification)
  end

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
