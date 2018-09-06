class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @team = Team.find(params[:team_id])
    @favourite = Favourite.create(team: @team, assignment: current_user.event_assignment)
    if @favourite.save
      flash[:notice] = 'Favourite Added'
    else
      flash[:alert] = 'Error adding Favourite'
    end
    redirect_to project_path(@team.current_project.identifier)
  end

  def destroy
    @favourite = Favourite.find_by(id: params[:id], assignment: current_user.event_assignment)
    if @favourite.present?
      @favourite.destroy
      flash[:notice] = 'Favourite Removed'
    else
      flash[:alert] = 'Problem removing favourite'
    end
    redirect_to project_path(@favourite.team.current_project.identifier)
  end
end
