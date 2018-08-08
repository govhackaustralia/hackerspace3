class TeamDataSetsController < ApplicationController
    before_action :authenticate_user!

  def new
    @team = Team.find(params[:team_id])
    @team_data_set = @team.team_data_sets.new
  end

  def create
    @team = Team.find(params[:team_id])
    @team_data_set = @team.team_data_sets.new(team_data_set_params)
    if @team_data_set.save
      flash[:notice] = 'New Team Data Set Created'
      redirect_to team_path(@team)
    else
      @team_data_set.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @team = Team.find(params[:team_id])
    @team_data_set = TeamDataSet.find(params[:id])
  end

  def update
    @team = Team.find(params[:team_id])
    @team_data_set = TeamDataSet.find(params[:id])
    if @team_data_set.update(team_data_set_params)
      flash[:notice] = 'New Team Data Set Updated'
      redirect_to team_path(@team)
    else
      @team_data_set.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def team_data_set_params
    params.require(:team_data_set).permit(:name, :description,
                                          :description_of_use, :url)
  end
end
