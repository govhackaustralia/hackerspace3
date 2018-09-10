class TeamManagement::TeamDataSetsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user_team_privileges!

  def index
    @team_data_sets = @team.team_data_sets
  end

  def new
    @team_data_set = @team.team_data_sets.new
  end

  def create
    @team_data_set = @team.team_data_sets.new(team_data_set_params)
    if @team_data_set.save
      flash[:notice] = 'New Team Data Set Created'
      redirect_to team_management_team_team_data_sets_path(@team)
    else
      flash[:alert] = @team_data_set.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @team_data_set = TeamDataSet.find(params[:id])
  end

  def update
    @team_data_set = TeamDataSet.find(params[:id])
    if @team_data_set.update(team_data_set_params)
      flash[:notice] = 'New Team Data Set Updated'
      redirect_to team_management_team_team_data_sets_path(@team)
    else
      flash[:alert] = @team_data_set.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @team_data_set = TeamDataSet.find(params[:id])
    @team_data_set.destroy
    redirect_to team_management_team_team_data_sets_path(@team)
  end

  private

  def check_user_team_privileges!
    @team = Team.find(params[:team_id])
    @competition = @team.competition
    return if @team.permission?(current_user) && @competition.in_competition_window?(@team.time_zone)
    if @team.permission?(current_user)
      flash[:notice] = 'The competition has closed.'
      redirect_to project_path(@team.current_project.identifier)
    else
      flash[:notice] = 'You do not have access permissions for this team.'
      redirect_to root_path
    end
  end

  def team_data_set_params
    params.require(:team_data_set).permit(:name, :description,
                                          :description_of_use, :url)
  end
end
