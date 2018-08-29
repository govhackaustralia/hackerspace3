class Admin::EntriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @challenge = Challenge.find(params[:challenge_id])
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
end
