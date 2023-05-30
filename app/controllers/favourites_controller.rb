# frozen_string_literal: true

class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def create
    favourite = Favourite.create favourite_params
    if favourite.save
      flash[:notice] = 'Favourite Added'
    else
      flash[:alert] = 'Error adding Favourite'
    end
    redirect_to project_path favourite.project.identifier
  end

  def destroy
    favourite = Favourite.find params[:id]
    favourite.destroy!
    redirect_to project_path(favourite.project.identifier),
      notice: 'Favourite Removed'
  end

  private

  def favourite_params
    params.require(:favourite).permit(:team_id).merge(
      assignment: current_user.event_assignment(@competition),
      holder: current_user.holder_for(@competition),
    )
  end
end
