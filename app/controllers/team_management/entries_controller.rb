class TeamManagement::EntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @team = Team.find(params[:team_id])
    @competition = @team.event.competition
  end

  def new
    @team = Team.find(params[:team_id])
    @challenge = Challenge.find(params[:challenge_id])
    @entry = @team.entries.new(challenge: @challenge)
    @checkpoints = Checkpoint.all
  end

  def create
    create_new_entry
    if @entry.save
      flash[:notice] = 'Challenge Entered'
      redirect_to challenge_path(@entry.challenge)
    else
      flash[:alert] = @entry.errors.full_messages.to_sentence
      render :new
    end
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
    redirect_to team_management_team_entries_path(@entry.team)
  end

  private

  def entry_params
    params.require(:entry).permit(:checkpoint_id, :justification, :challenge_id)
  end

  def create_new_entry
    @team = Team.find(params[:team_id])
    @entry = @team.entries.new(entry_params)
    @challenge = Challenge.find(params[:challenge_id])
    @entry.challenge = @challenge
  end
end
