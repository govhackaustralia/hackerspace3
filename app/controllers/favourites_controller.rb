class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def create
    team = Team.find params[:team_id]
    favourite = Favourite.create(
      team: team,
      assignment: current_user.event_assignment(team.competition),
      holder: @holder
    )
    handle_create favourite, team
  end

  def destroy
    favourite = Favourite.find id: params[:id]
    if favourite.present?
      favourite.destroy
      flash[:notice] = 'Favourite Removed'
    else
      flash[:alert] = 'Problem removing favourite'
    end
    redirect_to project_path favourite.team.current_project.identifier
  end

  private

  def handle_create(favourite, team)
    if favourite.save
      flash[:notice] = 'Favourite Added'
    else
      flash[:alert] = 'Error adding Favourite'
    end
    redirect_to project_path team.current_project.identifier
  end
end
