class Admin::Challenges::EntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @challenge = Challenge.find(params[:challenge_id])
    @entries = @challenge.entries
    @id_team_projects = Team.id_teams_projects(@entries.pluck(:team_id))
  end

  def edit
    @entry = Entry.find(params[:id])
    @team = @entry.team
    @checkpoint = @entry.checkpoint
    @challenge = @entry.challenge
  end

  def update
    update_entry
    if @entry.save
      flash[:notice] = 'Entry Updated'
      redirect_to admin_challenge_entries_path(@challenge)
    else
      @team = @entry.team
      @checkpoint = @entry.checkpoint
      flash[:alert] = @entry.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def update_entry
    @entry = Entry.find(params[:id])
    @challenge = @entry.challenge
    @entry.update(entry_params) if params[:entry].present?
  end

  def entry_params
    params.require(:entry).permit(:eligible)
  end

  def check_for_privileges
    return if current_user.region_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
