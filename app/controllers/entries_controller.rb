class EntriesController < ApplicationController
  before_action :authenticate_user!

  def new
    @team = Team.find(params[:team_id])
    @entry = @team.entries.new
    @challenges = Challenge.all
    @checkpoints = Checkpoint.all
  end

  def create
    @team = Team.find(params[:team_id])
    @entry = @team.entries.new(entry_params)
    if @entry.save
      flash[:notice] = 'Challenge Entered'
      redirect_to team_path(@team)
    else
      flash[:alert] = @entry.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def entry_params
    params.require(:entry).permit(:checkpoint_id, :justification,
                                          :challenge_id)
  end
end
