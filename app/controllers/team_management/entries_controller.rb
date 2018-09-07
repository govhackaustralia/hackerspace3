class TeamManagement::EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_team_privileges!

  def index
    @competition = @team.event.competition
  end

  def new
    @challenge = Challenge.find(params[:challenge_id])
    @entry = @team.entries.new(challenge: @challenge)
    @checkpoints = @team.available_checkpoints(@challenge)
  end

  def create
    create_new_entry
    if @entry.save
      flash[:notice] = 'Challenge Entered'
      redirect_to challenge_path(@entry.challenge)
    else
      flash[:alert] = @entry.errors.full_messages.to_sentence
      @checkpoints = @team.available_checkpoints(@challenge)
      render :new
    end
  end

  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy
    flash[:notice] = 'Challenge Entry Removed'
    redirect_to team_management_team_entries_path(@entry.team)
  end

  private

  def entry_params
    params.require(:entry).permit(:checkpoint_id, :justification, :challenge_id)
  end

  def create_new_entry
    @entry = @team.entries.new(entry_params)
    @challenge = Challenge.find(params[:challenge_id])
    @entry.challenge = @challenge
  end

  def check_user_team_privileges!
    @team = Team.find(params[:team_id])
    return if @team.permission?(current_user)
    flash[:notice] = 'You do not have access permissions for this team.'
    redirect_to root_path
  end
end
